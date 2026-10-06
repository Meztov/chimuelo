// =====================================================
// VERB DICE
// EL ORÁCULO DE LOS CUENTOS
// =====================================================

class VerbDice {

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
  // VERBOS
  // =====================================================

  String[] verbs = {
    "CORRER",
    "SALTAR",
    "VOLAR",
    "BUSCAR",
    "ESCAPAR",
    "EXPLORAR",
    "BAILAR",
    "CREAR",
    "DESCUBRIR",
    "AYUDAR",
    "LUCHAR",
    "SOÑAR"
  };


  // =====================================================
  // COLORES
  // =====================================================

  int[] faceColors = {
    color(255, 170, 190),
    color(170, 220, 255),
    color(190, 255, 190),
    color(255, 220, 150),
    color(210, 180, 255),
    color(255, 190, 150),
    color(170, 255, 230),
    color(255, 210, 240),
    color(190, 200, 255),
    color(255, 240, 170),
    color(200, 255, 220),
    color(240, 190, 255)
  };


  // =====================================================
  // CONSTRUCTOR
  // =====================================================

  VerbDice(float px, float py, float s) {

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

      if (millis() - rollStartTime > rollDuration) {
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
      int(random(verbs.length));
  }


  // =====================================================
  // TERMINAR
  // =====================================================

  void finishRoll() {

    isRolling = false;
    hasResult = true;

    selectedIndex =
      int(random(verbs.length));
  }


  // =====================================================
  // RESULTADO
  // =====================================================

  String getSelectedVerb() {

    if (!hasResult) {
      return "";
    }

    return verbs[selectedIndex];
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

    if (isHovering || isRolling) {

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

    float s = size * 0.55;


    
    // =================================================
    // 12 CARAS
    // =================================================

    for (int i = 0; i < 12; i++) {

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

      for (int j = 0; j < 5; j++) {

        float a =
          -HALF_PI +
          TWO_PI * j / 5.0;

        float px =
          cos(a) * s * 0.48;

        float py =
          sin(a) * s * 0.48;

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

      for (int j = 0; j < 5; j++) {

        float a =
          -HALF_PI +
          TWO_PI * j / 5.0;

        float px =
          cos(a) * s * 0.40;

        float py =
          sin(a) * s * 0.40;

        vertex(
          px,
          py,
          2
        );
      }

      endShape(CLOSE);


      // ===============================================
      // DIBUJO
      // ===============================================

      drawVerbIcon(
        i,
        s
      );


      // ===============================================
      // TEXTO
      // ===============================================

      drawVerbText(
        verbs[i],
        s
      );


      popMatrix();
    }
  }


  // =====================================================
  // TEXTO DEL VERBO
  // =====================================================

  void drawVerbText(
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
        10,
        size * 0.075
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
  // DIBUJOS DE LOS VERBOS
  // =====================================================

  void drawVerbIcon(
    int index,
    float s
  ) {

    float r =
      s * 0.23;


    // =================================================
    // CORRER
    // =================================================

    if (index == 0) {

      stroke(60, 60, 90);
      strokeWeight(5);

      line(0, -r * 0.3, -r * 0.2, r * 0.5);
      line(-r * 0.2, r * 0.5, -r * 0.8, r);
      line(-r * 0.2, r * 0.5, r * 0.7, r * 0.7);
      line(-r * 0.1, 0, -r * 0.8, -r * 0.5);
      line(-r * 0.1, 0, r * 0.8, -r * 0.3);

      fill(60, 60, 90);
      noStroke();

      ellipse(
        0,
        -r * 0.75,
        r * 0.45,
        r * 0.45
      );
    }


    // =================================================
    // SALTAR
    // =================================================

    else if (index == 1) {

      stroke(80, 60, 120);
      strokeWeight(5);

      line(0, -r * 0.3, 0, r * 0.5);
      line(0, r * 0.5, -r * 0.7, r);
      line(0, r * 0.5, r * 0.7, r);
      line(0, 0, -r * 0.8, -r * 0.7);
      line(0, 0, r * 0.8, -r * 0.7);

      fill(80, 60, 120);
      noStroke();

      ellipse(
        0,
        -r * 0.75,
        r * 0.45,
        r * 0.45
      );
    }


    // =================================================
    // VOLAR
    // =================================================

    else if (index == 2) {

      stroke(50, 100, 190);
      strokeWeight(6);

      line(0, r * 0.7, 0, -r * 0.3);
      line(0, -r * 0.2, -r, -r * 0.8);
      line(0, -r * 0.2, r, -r * 0.8);
      line(-r * 0.5, -r * 0.55, -r * 0.9, -r * 0.2);
      line(r * 0.5, -r * 0.55, r * 0.9, -r * 0.2);
    }


    // =================================================
    // BUSCAR
    // =================================================

    else if (index == 3) {

      noFill();

      stroke(50, 50, 90);
      strokeWeight(7);

      ellipse(
        -r * 0.2,
        -r * 0.2,
        r * 1.2,
        r * 1.2
      );

      line(
        r * 0.2,
        r * 0.2,
        r,
        r
      );
    }


    // =================================================
    // ESCAPAR
    // =================================================

    else if (index == 4) {

      stroke(100, 60, 130);
      strokeWeight(6);

      line(-r, 0, r, 0);
      line(r, 0, r * 0.35, -r * 0.5);
      line(r, 0, r * 0.35, r * 0.5);

      fill(100, 60, 130);
      noStroke();

      ellipse(
        -r * 0.7,
        -r * 0.7,
        r * 0.45,
        r * 0.45
      );
    }


    // =================================================
    // EXPLORAR
    // =================================================

    else if (index == 5) {

      noFill();

      stroke(50, 80, 120);
      strokeWeight(5);

      ellipse(
        0,
        0,
        r * 1.4,
        r * 1.4
      );

      line(
        0,
        0,
        r * 0.6,
        -r * 0.7
      );

      fill(255, 210, 60);
      noStroke();

      ellipse(
        -r,
        -r,
        r * 0.18,
        r * 0.18
      );

      ellipse(
        r,
        -r * 0.8,
        r * 0.18,
        r * 0.18
      );
    }


    // =================================================
    // BAILAR
    // =================================================

    else if (index == 6) {

      stroke(150, 60, 180);
      strokeWeight(5);

      line(0, -r * 0.3, 0, r * 0.6);
      line(0, 0, -r, -r * 0.7);
      line(0, 0, r, -r * 0.7);
      line(0, r * 0.6, -r, r);
      line(0, r * 0.6, r, r);

      fill(150, 60, 180);
      noStroke();

      ellipse(
        0,
        -r * 0.7,
        r * 0.45,
        r * 0.45
      );
    }


    // =================================================
    // CREAR
    // =================================================

    else if (index == 7) {

      stroke(70, 70, 100);
      strokeWeight(6);

      line(-r, r, r, -r);
      line(-r * 0.7, -r, r, -r);
      line(r, -r, r, -r * 0.2);

      stroke(255, 180, 40);

      line(
        -r,
        -r * 0.8,
        -r,
        -r * 0.3
      );

      line(
        -r * 1.25,
        -r * 0.55,
        -r * 0.75,
        -r * 0.55
      );
    }


    // =================================================
    // DESCUBRIR
    // =================================================

    else if (index == 8) {

      fill(255, 225, 70);
      noStroke();

      ellipse(
        0,
        -r * 0.1,
        r * 1.15,
        r * 1.15
      );

      stroke(100, 80, 50);
      strokeWeight(4);

      line(
        -r * 0.3,
        r * 0.5,
        r * 0.3,
        r * 0.5
      );

      line(
        -r * 0.2,
        r * 0.75,
        r * 0.2,
        r * 0.75
      );

      stroke(255, 190, 40);

      line(0, -r * 1.2, 0, -r * 1.7);
      line(-r, -r, -r * 1.3, -r * 1.3);
      line(r, -r, r * 1.3, -r * 1.3);
    }


    // =================================================
    // AYUDAR
    // =================================================

    else if (index == 9) {

      stroke(210, 70, 110);
      strokeWeight(7);

      line(-r, 0, 0, r * 0.6);
      line(r, 0, 0, r * 0.6);

      fill(210, 70, 110);
      noStroke();

      ellipse(
        -r,
        0,
        r * 0.55,
        r * 0.55
      );

      ellipse(
        r,
        0,
        r * 0.55,
        r * 0.55
      );
    }


    // =================================================
    // LUCHAR
    // =================================================

    else if (index == 10) {

      stroke(80, 50, 90);
      strokeWeight(7);

      line(-r, -r, r, r);
      line(r, -r, -r, r);

      stroke(255, 210, 50);
      strokeWeight(4);

      line(
        0,
        -r * 0.4,
        0,
        r * 0.4
      );

      line(
        -r * 0.4,
        0,
        r * 0.4,
        0
      );
    }


    // =================================================
    // SOÑAR
    // =================================================

    else if (index == 11) {

      fill(255);
      noStroke();

      ellipse(
        -r * 0.5,
        0,
        r,
        r * 0.7
      );

      ellipse(
        0,
        -r * 0.25,
        r * 1.2,
        r
      );

      ellipse(
        r * 0.5,
        0,
        r,
        r * 0.7
      );

      fill(255, 220, 60);

      ellipse(
        -r,
        -r,
        r * 0.2,
        r * 0.2
      );

      ellipse(
        r,
        -r * 0.8,
        r * 0.2,
        r * 0.2
      );
    }
  }
}
