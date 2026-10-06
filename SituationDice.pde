// =====================================================
// SITUATION DICE
// EL ORÁCULO DE LOS CUENTOS
// =====================================================

class SituationDice {

  float x;
  float y;
  float size;

  float rotX = 0;
  float rotY = 0;
  float rotZ = 0;

  float rotationSpeed = 0.008;

  boolean isRolling = false;
  boolean isHovering = false;
  boolean hasResult = false;

  int rollStartTime = 0;
  int rollDuration = 2200;

  int selectedIndex = 0;


  // =====================================================
  // SITUACIONES
  // =====================================================

  String[] situations = {

    "EN UN BOSQUE",
    "EN EL ESPACIO",
    "EN UN CASTILLO",
    "EN UNA CIUDAD",
    "EN UNA CUEVA",
    "EN EL MAR",
    "EN UNA ISLA",
    "EN UNA MONTAÑA",
    "EN UNA ESCUELA",
    "EN UN PLANETA",
    "LUGAR MISTERIOSO",
    "MUNDO MÁGICO"

  };


  // =====================================================
  // COLORES
  // =====================================================

  int[] faceColors = {

    color(170, 230, 190),
    color(170, 210, 255),
    color(220, 190, 255),
    color(255, 190, 210),
    color(180, 170, 150),
    color(150, 220, 235),
    color(255, 220, 150),
    color(190, 210, 255),
    color(255, 230, 170),
    color(200, 190, 255),
    color(210, 190, 230),
    color(240, 190, 255)

  };


  // =====================================================
  // CONSTRUCTOR
  // =====================================================

  SituationDice(
    float px,
    float py,
    float s
  ) {

    x = px;
    y = py;
    size = s;

  }


  // =====================================================
  // UPDATE
  // =====================================================

  void update() {

    if (isRolling) {

      rotX += 0.055;
      rotY += 0.075;
      rotZ += 0.035;

      if (
        millis() - rollStartTime >
        rollDuration
      ) {

        finishRoll();

      }

    } else {

      rotX += rotationSpeed;
      rotY += rotationSpeed * 1.3;
      rotZ += rotationSpeed * 0.7;

    }

  }


  // =====================================================
  // MANO
  // =====================================================

  void checkHand(PVector hand) {

    float distance = dist(
      hand.x,
      hand.y,
      x,
      y
    );

    isHovering =
      distance < size * 1.15;

  }


  // =====================================================
  // PINCH
  // =====================================================

  void handlePinch(PVector hand) {

    if (isRolling) {

      return;

    }

    if (isHovering) {

      startRoll();

    }

  }


  // =====================================================
  // LANZAR
  // =====================================================

  void startRoll() {

    isRolling = true;

    hasResult = false;

    rollStartTime = millis();

    selectedIndex =
      int(random(situations.length));

  }


  // =====================================================
  // TERMINAR
  // =====================================================

  void finishRoll() {

    isRolling = false;

    hasResult = true;

    selectedIndex =
      int(random(situations.length));

  }


  // =====================================================
  // RESULTADO
  // =====================================================

  String getSelectedSituation() {

    if (!hasResult) {

      return "";

    }

    return situations[selectedIndex];

  }


  // =====================================================
  // DISPLAY
  // =====================================================

  void display() {

    pushMatrix();

    translate(
      x,
      y,
      0
    );


    // =================================================
    // HALO
    // =================================================

    hint(DISABLE_DEPTH_TEST);

    if (
      isHovering ||
      isRolling
    ) {

      noFill();

      stroke(
        255,
        220,
        100,
        100
      );

      strokeWeight(3);

      float pulse =
        sin(frameCount * 0.08) * 10;

      ellipse(
        0,
        0,
        size * 1.7 + pulse,
        size * 1.7 + pulse
      );

      stroke(
        200,
        150,
        255,
        70
      );

      ellipse(
        0,
        0,
        size * 1.9 + pulse,
        size * 1.9 + pulse
      );

    }

    hint(ENABLE_DEPTH_TEST);


    // =================================================
    // LUZ
    // =================================================

    if (isHovering) {

      pointLight(
        255,
        230,
        150,
        0,
        -100,
        400
      );

    } else {

      pointLight(
        255,
        255,
        255,
        0,
        -100,
        400
      );

    }


    // =================================================
    // ROTACIÓN
    // =================================================

    rotateX(rotX);
    rotateY(rotY);
    rotateZ(rotZ);


    // =================================================
    // DODECAEDRO
    // =================================================

    drawDodecahedron();


    popMatrix();

  }


  // =====================================================
  // DODECAEDRO
  // =====================================================

  void drawDodecahedron() {

    float s =
      size * 0.55;


    // =================================================
    // 12 CARAS
    // =================================================

    for (
      int i = 0;
      i < 12;
      i++
    ) {

      pushMatrix();

      float angle =
        TWO_PI * i / 12.0;

      rotateY(angle);

      translate(
        0,
        0,
        s
      );


      // ===============================================
      // CARA
      // ===============================================

      fill(
        faceColors[i]
      );

      stroke(
        255,
        255,
        255,
        210
      );

      strokeWeight(2);

      beginShape();


      for (
        int j = 0;
        j < 5;
        j++
      ) {

        float a =
          -HALF_PI +
          TWO_PI * j / 5.0;

        float px =
          cos(a) *
          s *
          0.48;

        float py =
          sin(a) *
          s *
          0.48;

        vertex(
          px,
          py,
          0
        );

      }

      endShape(CLOSE);


      // ===============================================
      // BORDE INTERIOR
      // ===============================================

      noFill();

      stroke(
        255,
        255,
        255,
        120
      );

      strokeWeight(1);

      beginShape();


      for (
        int j = 0;
        j < 5;
        j++
      ) {

        float a =
          -HALF_PI +
          TWO_PI * j / 5.0;

        float px =
          cos(a) *
          s *
          0.40;

        float py =
          sin(a) *
          s *
          0.40;

        vertex(
          px,
          py,
          2
        );

      }

      endShape(CLOSE);


      // ===============================================
      // ICONO
      // ===============================================

      drawSituationIcon(
        i,
        s
      );


      // ===============================================
      // TEXTO
      // ===============================================

      drawSituationText(
        situations[i],
        s
      );


      popMatrix();

    }

  }


  // =====================================================
  // TEXTO
  // =====================================================

  void drawSituationText(
    String word,
    float s
  ) {

    hint(DISABLE_DEPTH_TEST);

    pushMatrix();

    translate(
      0,
      s * 0.27,
      5
    );

    fill(
      50,
      35,
      80
    );

    noStroke();

    textAlign(
      CENTER,
      CENTER
    );

    textSize(
      max(
        8,
        size * 0.055
      )
    );


    text(
      word,
      0,
      0
    );


    popMatrix();

    hint(ENABLE_DEPTH_TEST);

  }


  // =====================================================
  // ICONOS
  // =====================================================

  void drawSituationIcon(
    int index,
    float s
  ) {

    float r =
      s * 0.23;


    // =================================================
    // BOSQUE
    // =================================================

    if (index == 0) {

      stroke(
        60,
        110,
        70
      );

      strokeWeight(5);

      line(
        0,
        r,
        0,
        -r
      );

      line(
        0,
        -r * 0.4,
        -r * 0.7,
        -r * 0.9
      );

      line(
        0,
        -r * 0.1,
        r * 0.7,
        -r * 0.7
      );

      fill(
        80,
        170,
        90
      );

      noStroke();

      ellipse(
        -r * 0.6,
        -r * 0.8,
        r,
        r * 0.8
      );

      ellipse(
        r * 0.6,
        -r * 0.7,
        r,
        r * 0.8
      );

    }


    // =================================================
    // ESPACIO
    // =================================================

    else if (index == 1) {

      fill(
        80,
        70,
        150
      );

      noStroke();

      ellipse(
        0,
        0,
        r * 1.5,
        r * 1.5
      );

      fill(
        255,
        230,
        80
      );

      ellipse(
        -r,
        -r,
        r * 0.18,
        r * 0.18
      );

      ellipse(
        r,
        -r * 0.7,
        r * 0.20,
        r * 0.20
      );

      ellipse(
        r * 0.8,
        r * 0.8,
        r * 0.15,
        r * 0.15
      );

    }


    // =================================================
    // CASTILLO
    // =================================================

    else if (index == 2) {

      fill(
        120,
        100,
        160
      );

      noStroke();

      rect(
        -r * 0.8,
        -r * 0.2,
        r * 1.6,
        r * 1.1
      );

      triangle(
        -r * 0.8,
        -r * 0.2,
        -r * 0.8,
        -r,
        -r * 0.3,
        -r * 0.2
      );

      triangle(
        r * 0.3,
        -r * 0.2,
        r * 0.8,
        -r,
        r * 0.8,
        -r * 0.2
      );

      fill(
        255,
        220,
        100
      );

      rect(
        -r * 0.18,
        r * 0.25,
        r * 0.36,
        r * 0.65
      );

    }


    // =================================================
    // CIUDAD
    // =================================================

    else if (index == 3) {

      fill(
        100,
        120,
        170
      );

      noStroke();

      rect(
        -r,
        -r * 0.3,
        r * 0.5,
        r * 1.2
      );

      rect(
        -r * 0.3,
        -r * 0.8,
        r * 0.6,
        r * 1.7
      );

      rect(
        r * 0.4,
        -r * 0.5,
        r * 0.6,
        r * 1.4
      );

      fill(
        255,
        220,
        80
      );

      ellipse(
        -r * 0.75,
        -r * 0.05,
        r * 0.12,
        r * 0.12
      );

      ellipse(
        0,
        -r * 0.45,
        r * 0.12,
        r * 0.12
      );

      ellipse(
        r * 0.7,
        -r * 0.15,
        r * 0.12,
        r * 0.12
      );

    }


    // =================================================
    // CUEVA
    // =================================================

    else if (index == 4) {

      fill(
        80,
        65,
        80
      );

      noStroke();

      ellipse(
        0,
        0,
        r * 1.7,
        r * 1.8
      );

      fill(
        210,
        190,
        150
      );

      triangle(
        -r,
        -r,
        -r * 0.5,
        -r * 0.1,
        -r * 0.8,
        r
      );

      triangle(
        r,
        -r,
        r * 0.5,
        -r * 0.1,
        r * 0.8,
        r
      );

    }


    // =================================================
    // MAR
    // =================================================

    else if (index == 5) {

      noFill();

      stroke(
        50,
        120,
        190
      );

      strokeWeight(5);

      arc(
        0,
        0,
        r * 1.8,
        r,
        0,
        PI
      );

      arc(
        -r * 0.4,
        r * 0.3,
        r * 1.4,
        r * 0.8,
        0,
        PI
      );

      fill(
        80,
        150,
        210
      );

      noStroke();

      ellipse(
        r * 0.5,
        -r * 0.4,
        r * 0.5,
        r * 0.3
      );

    }


    // =================================================
    // ISLA
    // =================================================

    else if (index == 6) {

      fill(
        220,
        190,
        100
      );

      noStroke();

      ellipse(
        0,
        r * 0.4,
        r * 1.8,
        r * 0.6
      );

      fill(
        70,
        160,
        90
      );

      triangle(
        0,
        -r,
        -r * 0.6,
        r * 0.3,
        r * 0.6,
        r * 0.3
      );

      stroke(
        80,
        130,
        70
      );

      strokeWeight(5);

      line(
        0,
        -r * 0.4,
        0,
        r * 0.2
      );

    }


    // =================================================
    // MONTAÑA
    // =================================================

    else if (index == 7) {

      fill(
        100,
        130,
        160
      );

      noStroke();

      triangle(
        -r,
        r,
        0,
        -r,
        r,
        r
      );

      fill(
        245,
        245,
        255
      );

      triangle(
        0,
        -r,
        -r * 0.3,
        -r * 0.25,
        r * 0.3,
        -r * 0.25
      );

    }


    // =================================================
    // ESCUELA
    // =================================================

    else if (index == 8) {

      fill(
        220,
        160,
        100
      );

      noStroke();

      rect(
        -r,
        -r * 0.1,
        r * 2,
        r
      );

      triangle(
        -r * 1.1,
        -r * 0.1,
        0,
        -r,
        r * 1.1,
        -r * 0.1
      );

      fill(
        100,
        80,
        100
      );

      rect(
        -r * 0.25,
        r * 0.2,
        r * 0.5,
        r * 0.7
      );

    }


    // =================================================
    // PLANETA
    // =================================================

    else if (index == 9) {

      fill(
        100,
        150,
        210
      );

      noStroke();

      ellipse(
        0,
        0,
        r * 1.5,
        r * 1.5
      );

      noFill();

      stroke(
        230,
        190,
        100
      );

      strokeWeight(4);

      ellipse(
        0,
        0,
        r * 2.1,
        r * 0.6
      );

    }


    // =================================================
    // LUGAR MISTERIOSO
    // =================================================

    else if (index == 10) {

      fill(
        90,
        70,
        130
      );

      noStroke();

      ellipse(
        0,
        0,
        r * 1.5,
        r * 1.5
      );

      fill(
        255,
        220,
        80
      );

      ellipse(
        -r * 0.4,
        -r * 0.2,
        r * 0.25,
        r * 0.25
      );

      ellipse(
        r * 0.4,
        -r * 0.2,
        r * 0.25,
        r * 0.25
      );

      stroke(
        255,
        220,
        80
      );

      strokeWeight(3);

      line(
        -r,
        -r,
        -r * 0.6,
        -r * 1.4
      );

      line(
        r,
        -r,
        r * 0.6,
        -r * 1.4
      );

    }


    // =================================================
    // MUNDO MÁGICO
    // =================================================

    else if (index == 11) {

      fill(
        190,
        120,
        230
      );

      noStroke();

      ellipse(
        0,
        0,
        r * 1.5,
        r * 1.5
      );

      stroke(
        255,
        220,
        80
      );

      strokeWeight(4);

      line(
        0,
        -r * 1.2,
        0,
        r * 1.2
      );

      line(
        -r * 1.2,
        0,
        r * 1.2,
        0
      );

      line(
        -r * 0.8,
        -r * 0.8,
        r * 0.8,
        r * 0.8
      );

      line(
        r * 0.8,
        -r * 0.8,
        -r * 0.8,
        r * 0.8
      );

      fill(
        255,
        240,
        120
      );

      noStroke();

      ellipse(
        -r * 0.8,
        -r * 0.8,
        r * 0.18,
        r * 0.18
      );

      ellipse(
        r * 0.8,
        r * 0.7,
        r * 0.18,
        r * 0.18
      );

    }

  }

}
