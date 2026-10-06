class CharacterDice {

  // =====================================================
  // POSICIÓN Y TAMAÑO
  // =====================================================

  float x;
  float y;
  float size;

  // =====================================================
  // ROTACIÓN
  // =====================================================

  float rotX = 0;
  float rotY = 0;
  float rotZ = 0;

  float rotationSpeed = 0.008;

  // =====================================================
  // ESTADO
  // =====================================================

  boolean isRolling = false;
  boolean isHovering = false;
  boolean hasResult = false;

  int rollStartTime;
  int rollDuration = 2200;

  int selectedIndex = -1;

  // =====================================================
  // PERSONAJES
  // =====================================================

  String[] characters = {

    "PERRO",
    "NIÑA",
    "PRÍNCIPE",
    "ASTRONAUTA",
    "ROBOT",
    "ZORRO",
    "DRAGÓN",
    "MAGA",
    "ALIEN",
    "SIRENA",
    "FANTASMA",
    "PERSONA"

  };

  // =====================================================
  // COLORES DE LAS CARAS
  // =====================================================

  int[] faceColors = {

    color(255, 150, 150),
    color(255, 190, 120),
    color(255, 230, 130),
    color(180, 230, 170),

    color(150, 220, 255),
    color(160, 180, 255),
    color(200, 160, 255),
    color(240, 160, 230),

    color(255, 170, 210),
    color(180, 240, 230),
    color(210, 210, 210),
    color(230, 190, 150)

  };


  // =====================================================
  // CONSTRUCTOR
  // =====================================================

  CharacterDice(
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

    if (!isRolling) {

      rotY += rotationSpeed;
      rotX += rotationSpeed * 0.3;

    } else {

      rotY += 0.25;
      rotX += 0.17;
      rotZ += 0.11;

      if (millis() - rollStartTime > rollDuration) {

        finishRoll();

      }

    }

  }


  // =====================================================
  // COMPROBAR MANO
  // =====================================================

  void checkHand(PVector hand) {

    if (hand == null) {

      isHovering = false;
      return;

    }

    float distance = dist(
      hand.x,
      hand.y,
      x,
      y
    );

    float interactionRadius = size * 0.95;

    isHovering =
      distance < interactionRadius;

  }


  // =====================================================
  // PINCH
  // =====================================================

  void handlePinch(PVector hand) {

    if (hand == null) {
      return;
    }

    float distance = dist(
      hand.x,
      hand.y,
      x,
      y
    );

    if (distance < size * 0.95) {

      if (!isRolling) {

        startRoll();

      }

    }

  }


  // =====================================================
  // COMENZAR LANZAMIENTO
  // =====================================================

  void startRoll() {

    isRolling = true;

    hasResult = false;

    selectedIndex = -1;

    rollStartTime = millis();

    println(
      "🎲 LANZANDO EL ORÁCULO..."
    );

  }


  // =====================================================
  // TERMINAR LANZAMIENTO
  // =====================================================

  void finishRoll() {

    isRolling = false;

    selectedIndex =
      int(random(characters.length));

    hasResult = true;

    println(
      "✨ PERSONAJE: "
      + characters[selectedIndex]
    );

  }


  // =====================================================
  // OBTENER RESULTADO
  // =====================================================

  String getSelectedCharacter() {

    if (
      selectedIndex >= 0 &&
      selectedIndex < characters.length
    ) {

      return characters[selectedIndex];

    }

    return "";

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

    int faces = 12;

    for (int i = 0; i < faces; i++) {

      pushMatrix();

      float angle =
        TWO_PI / faces * i;

      rotateY(angle);

      translate(
        0,
        0,
        size * 0.43
      );


      // -------------------------------------------------
      // CARA
      // -------------------------------------------------

      fill(
        faceColors[i]
      );

      stroke(
        255,
        255,
        255,
        220
      );

      strokeWeight(3);


      beginShape();

      for (int v = 0; v < 5; v++) {

        float a =
          TWO_PI / 5 * v
          - HALF_PI;

        float radius =
          size * 0.32;

        vertex(
          cos(a) * radius,
          sin(a) * radius
        );

      }

      endShape(CLOSE);


      // -------------------------------------------------
      // BORDE INTERIOR
      // -------------------------------------------------

      noFill();

      stroke(
        255,
        255,
        255,
        100
      );

      strokeWeight(1);


      beginShape();

      for (int v = 0; v < 5; v++) {

        float a =
          TWO_PI / 5 * v
          - HALF_PI;

        float radius =
          size * 0.25;

        vertex(
          cos(a) * radius,
          sin(a) * radius
        );

      }

      endShape(CLOSE);


      // =================================================
      // ILUSTRACIÓN
      // =================================================

      drawCharacterIcon(i);


      // -------------------------------------------------
      // NOMBRE
      // -------------------------------------------------

      pushMatrix();

      translate(
        0,
        size * 0.25,
        4
      );

      hint(DISABLE_DEPTH_TEST);

      fill(40);

      textAlign(
        CENTER,
        CENTER
      );

      textSize(
        max(
          9,
          size * 0.045
        )
      );

      text(
        getShortName(i),
        0,
        0
      );

      hint(ENABLE_DEPTH_TEST);

      popMatrix();


      popMatrix();

    }

  }


  // =====================================================
  // ILUSTRACIONES
  // =====================================================

  void drawCharacterIcon(int index) {

    pushMatrix();

    hint(DISABLE_DEPTH_TEST);

    translate(
      0,
      -size * 0.06,
      6
    );

    float s =
      size * 0.18;

    stroke(
      50,
      40,
      60
    );

    strokeWeight(2);

    // ===================================================
    // PERRO
    // ===================================================

    if (index == 0) {

      drawDog(s);

    }


    // ===================================================
    // NIÑA
    // ===================================================

    else if (index == 1) {

      drawGirl(s);

    }


    // ===================================================
    // PRÍNCIPE
    // ===================================================

    else if (index == 2) {

      drawPrince(s);

    }


    // ===================================================
    // ASTRONAUTA
    // ===================================================

    else if (index == 3) {

      drawAstronaut(s);

    }


    // ===================================================
    // ROBOT
    // ===================================================

    else if (index == 4) {

      drawRobot(s);

    }


    // ===================================================
    // ZORRO
    // ===================================================

    else if (index == 5) {

      drawFox(s);

    }


    // ===================================================
    // DRAGÓN
    // ===================================================

    else if (index == 6) {

      drawDragon(s);

    }


    // ===================================================
    // MAGA
    // ===================================================

    else if (index == 7) {

      drawMage(s);

    }


    // ===================================================
    // ALIEN
    // ===================================================

    else if (index == 8) {

      drawAlien(s);

    }


    // ===================================================
    // SIRENA
    // ===================================================

    else if (index == 9) {

      drawMermaid(s);

    }


    // ===================================================
    // FANTASMA
    // ===================================================

    else if (index == 10) {

      drawGhost(s);

    }


    // ===================================================
    // PERSONA
    // ===================================================

    else if (index == 11) {

      drawPerson(s);

    }

    hint(ENABLE_DEPTH_TEST);

    popMatrix();

  }


  // =====================================================
  // PERRO
  // =====================================================

  void drawDog(float s) {

    // orejas
    fill(130, 80, 50);

    triangle(
      -s * 0.75, -s * 0.55,
      -s * 0.25, -s * 0.25,
      -s * 0.65, s * 0.1
    );

    triangle(
      s * 0.75, -s * 0.55,
      s * 0.25, -s * 0.25,
      s * 0.65, s * 0.1
    );

    // cabeza
    fill(190, 130, 80);

    ellipse(
      0,
      0,
      s * 1.5,
      s * 1.35
    );

    // hocico
    fill(235, 190, 140);

    ellipse(
      0,
      s * 0.35,
      s * 0.75,
      s * 0.45
    );

    // ojos
    fill(30);

    ellipse(
      -s * 0.28,
      -s * 0.12,
      s * 0.16,
      s * 0.18
    );

    ellipse(
      s * 0.28,
      -s * 0.12,
      s * 0.16,
      s * 0.18
    );

    // nariz
    ellipse(
      0,
      s * 0.28,
      s * 0.18,
      s * 0.13
    );

  }


  // =====================================================
  // NIÑA
  // =====================================================

  void drawGirl(float s) {

    // cabello
    fill(100, 55, 35);

    ellipse(
      0,
      -s * 0.1,
      s * 1.45,
      s * 1.55
    );

    // cara
    fill(255, 205, 170);

    ellipse(
      0,
      -s * 0.05,
      s * 1.05,
      s * 1.15
    );

    // cabello lateral
    fill(100, 55, 35);

    ellipse(
      -s * 0.55,
      s * 0.15,
      s * 0.35,
      s * 0.85
    );

    ellipse(
      s * 0.55,
      s * 0.15,
      s * 0.35,
      s * 0.85
    );

    // ojos
    fill(40);

    ellipse(
      -s * 0.22,
      -s * 0.1,
      s * 0.13,
      s * 0.16
    );

    ellipse(
      s * 0.22,
      -s * 0.1,
      s * 0.13,
      s * 0.16
    );

    // sonrisa
    noFill();

    arc(
      0,
      s * 0.15,
      s * 0.45,
      s * 0.25,
      0,
      PI
    );

  }


  // =====================================================
  // PRÍNCIPE
  // =====================================================

  void drawPrince(float s) {

    // cabello
    fill(80, 50, 30);

    ellipse(
      0,
      -s * 0.35,
      s * 1.25,
      s * 0.65
    );

    // cara
    fill(255, 210, 175);

    ellipse(
      0,
      0,
      s * 1.05,
      s * 1.2
    );

    // corona
    fill(255, 210, 40);

    triangle(
      -s * 0.55, -s * 0.55,
      -s * 0.2, -s * 1.05,
      0, -s * 0.55
    );

    triangle(
      -s * 0.2, -s * 0.55,
      0, -s * 1.05,
      s * 0.2, -s * 0.55
    );

    triangle(
      0, -s * 0.55,
      s * 0.2, -s * 1.05,
      s * 0.55, -s * 0.55
    );

    rect(
      -s * 0.55,
      -s * 0.55,
      s * 1.1,
      s * 0.2
    );

    // ojos
    fill(30);

    ellipse(
      -s * 0.2,
      -s * 0.05,
      s * 0.12,
      s * 0.15
    );

    ellipse(
      s * 0.2,
      -s * 0.05,
      s * 0.12,
      s * 0.15
    );

  }


  // =====================================================
  // ASTRONAUTA
  // =====================================================

  void drawAstronaut(float s) {

    // casco
    fill(230);

    ellipse(
      0,
      0,
      s * 1.55,
      s * 1.55
    );

    // visor
    fill(60, 100, 130);

    ellipse(
      0,
      0,
      s * 1.05,
      s * 0.75
    );

    // reflejo
    fill(180, 230, 255);

    ellipse(
      -s * 0.25,
      -s * 0.18,
      s * 0.25,
      s * 0.15
    );

    // cuerpo
    fill(245);

    rect(
      -s * 0.55,
      s * 0.65,
      s * 1.1,
      s * 0.45,
      10
    );

  }


  // =====================================================
  // ROBOT
  // =====================================================

  void drawRobot(float s) {

    // cabeza
    fill(170, 180, 190);

    rect(
      -s * 0.7,
      -s * 0.65,
      s * 1.4,
      s * 1.15,
      12
    );

    // antena
    strokeWeight(3);

    line(
      0,
      -s * 0.65,
      0,
      -s * 0.95
    );

    fill(255, 80, 100);

    ellipse(
      0,
      -s * 1.02,
      s * 0.18,
      s * 0.18
    );

    // ojos
    fill(50, 230, 255);

    ellipse(
      -s * 0.3,
      -s * 0.2,
      s * 0.22,
      s * 0.22
    );

    ellipse(
      s * 0.3,
      -s * 0.2,
      s * 0.22,
      s * 0.22
    );

    // boca
    fill(50);

    rect(
      -s * 0.4,
      s * 0.15,
      s * 0.8,
      s * 0.18
    );

  }


  // =====================================================
  // ZORRO
  // =====================================================

  void drawFox(float s) {

    fill(230, 100, 40);

    triangle(
      -s * 0.7, -s * 0.55,
      -s * 0.45, -s * 1.0,
      -s * 0.05, -s * 0.45
    );

    triangle(
      s * 0.7, -s * 0.55,
      s * 0.45, -s * 1.0,
      s * 0.05, -s * 0.45
    );

    ellipse(
      0,
      0,
      s * 1.5,
      s * 1.35
    );

    // hocico
    fill(250, 230, 210);

    triangle(
      -s * 0.55, s * 0.1,
      0, s * 0.65,
      s * 0.55, s * 0.1
    );

    // ojos
    fill(30);

    ellipse(
      -s * 0.25,
      -s * 0.15,
      s * 0.15,
      s * 0.2
    );

    ellipse(
      s * 0.25,
      -s * 0.15,
      s * 0.15,
      s * 0.2
    );

    // nariz
    fill(30);

    ellipse(
      0,
      s * 0.38,
      s * 0.18,
      s * 0.13
    );

  }


  // =====================================================
  // DRAGÓN
  // =====================================================

  void drawDragon(float s) {

    fill(100, 200, 100);

    // cabeza
    ellipse(
      0,
      0,
      s * 1.45,
      s * 1.3
    );

    // cuernos
    fill(240, 210, 100);

    triangle(
      -s * 0.4, -s * 0.45,
      -s * 0.65, -s * 0.95,
      -s * 0.1, -s * 0.55
    );

    triangle(
      s * 0.4, -s * 0.45,
      s * 0.65, -s * 0.95,
      s * 0.1, -s * 0.55
    );

    // ojos
    fill(255, 230, 50);

    ellipse(
      -s * 0.28,
      -s * 0.1,
      s * 0.22,
      s * 0.25
    );

    ellipse(
      s * 0.28,
      -s * 0.1,
      s * 0.22,
      s * 0.25
    );

    fill(30);

    ellipse(
      -s * 0.28,
      -s * 0.1,
      s * 0.06,
      s * 0.16
    );

    ellipse(
      s * 0.28,
      -s * 0.1,
      s * 0.06,
      s * 0.16
    );

    // nariz
    fill(50);

    ellipse(
      -s * 0.15,
      s * 0.25,
      s * 0.1,
      s * 0.08
    );

    ellipse(
      s * 0.15,
      s * 0.25,
      s * 0.1,
      s * 0.08
    );

  }


  // =====================================================
  // MAGA
  // =====================================================

  void drawMage(float s) {

    // cabello
    fill(80, 40, 100);

    ellipse(
      0,
      0,
      s * 1.45,
      s * 1.5
    );

    // cara
    fill(255, 210, 180);

    ellipse(
      0,
      0,
      s * 0.9,
      s * 1.0
    );

    // sombrero
    fill(100, 60, 180);

    triangle(
      -s * 0.7,
      -s * 0.55,
      s * 0.7,
      -s * 0.55,
      0,
      -s * 1.25
    );

    ellipse(
      0,
      -s * 0.52,
      s * 1.5,
      s * 0.25
    );

    // estrella
    fill(255, 230, 80);

    star(
      0,
      -s * 0.8,
      s * 0.12,
      s * 0.23,
      5
    );

    // ojos
    fill(30);

    ellipse(
      -s * 0.2,
      -s * 0.02,
      s * 0.12,
      s * 0.15
    );

    ellipse(
      s * 0.2,
      -s * 0.02,
      s * 0.12,
      s * 0.15
    );

  }


  // =====================================================
  // ALIEN
  // =====================================================

  void drawAlien(float s) {

    // cabeza
    fill(120, 240, 150);

    ellipse(
      0,
      0,
      s * 1.55,
      s * 1.65
    );

    // ojos
    fill(30, 50, 70);

    ellipse(
      -s * 0.32,
      -s * 0.05,
      s * 0.35,
      s * 0.5
    );

    ellipse(
      s * 0.32,
      -s * 0.05,
      s * 0.35,
      s * 0.5
    );

    // sonrisa
    noFill();

    strokeWeight(2);

    arc(
      0,
      s * 0.25,
      s * 0.5,
      s * 0.25,
      0,
      PI
    );

  }


  // =====================================================
  // SIRENA
  // =====================================================

  void drawMermaid(float s) {

    // cabello
    fill(230, 80, 150);

    ellipse(
      0,
      -s * 0.15,
      s * 1.55,
      s * 1.5
    );

    // cara
    fill(255, 205, 180);

    ellipse(
      0,
      -s * 0.05,
      s * 0.95,
      s * 1.05
    );

    // cabello lateral
    fill(230, 80, 150);

    ellipse(
      -s * 0.55,
      s * 0.2,
      s * 0.35,
      s * 0.9
    );

    ellipse(
      s * 0.55,
      s * 0.2,
      s * 0.35,
      s * 0.9
    );

    // ojos
    fill(40);

    ellipse(
      -s * 0.2,
      -s * 0.1,
      s * 0.12,
      s * 0.15
    );

    ellipse(
      s * 0.2,
      -s * 0.1,
      s * 0.12,
      s * 0.15
    );

    // cola
    fill(70, 180, 220);

    triangle(
      -s * 0.35,
      s * 0.5,
      s * 0.35,
      s * 0.5,
      0,
      s * 0.95
    );

  }


  // =====================================================
  // FANTASMA
  // =====================================================

  void drawGhost(float s) {

    fill(
      245,
      245,
      255,
      220
    );

    beginShape();

    vertex(
      -s * 0.65,
      s * 0.65
    );

    vertex(
      -s * 0.65,
      -s * 0.2
    );

    bezierVertex(
      -s * 0.65,
      -s * 0.8,
      s * 0.65,
      -s * 0.8,
      s * 0.65,
      -s * 0.2
    );

    vertex(
      s * 0.65,
      s * 0.65
    );

    vertex(
      s * 0.3,
      s * 0.45
    );

    vertex(
      0,
      s * 0.7
    );

    vertex(
      -s * 0.3,
      s * 0.45
    );

    endShape(CLOSE);

    // ojos
    fill(60, 40, 100);

    ellipse(
      -s * 0.25,
      -s * 0.1,
      s * 0.18,
      s * 0.3
    );

    ellipse(
      s * 0.25,
      -s * 0.1,
      s * 0.18,
      s * 0.3
    );

  }


  // =====================================================
  // PERSONA
  // =====================================================

  void drawPerson(float s) {

    // cabello
    fill(60, 45, 35);

    ellipse(
      0,
      -s * 0.15,
      s * 1.25,
      s * 1.3
    );

    // cara
    fill(255, 205, 175);

    ellipse(
      0,
      0,
      s * 0.95,
      s * 1.05
    );

    // cuerpo
    fill(80, 130, 220);

    rect(
      -s * 0.45,
      s * 0.45,
      s * 0.9,
      s * 0.65,
      10
    );

    // ojos
    fill(30);

    ellipse(
      -s * 0.2,
      -s * 0.05,
      s * 0.12,
      s * 0.15
    );

    ellipse(
      s * 0.2,
      -s * 0.05,
      s * 0.12,
      s * 0.15
    );

    // sonrisa
    noFill();

    arc(
      0,
      s * 0.15,
      s * 0.4,
      s * 0.22,
      0,
      PI
    );

  }


  // =====================================================
  // ESTRELLA
  // =====================================================

  void star(
    float x,
    float y,
    float radius1,
    float radius2,
    int npoints
  ) {

    float angle =
      TWO_PI / npoints;

    float halfAngle =
      angle / 2.0;

    beginShape();

    for (
      float a = -HALF_PI;
      a < TWO_PI - HALF_PI;
      a += angle
    ) {

      float sx =
        x + cos(a) * radius2;

      float sy =
        y + sin(a) * radius2;

      vertex(sx, sy);

      sx =
        x + cos(a + halfAngle) * radius1;

      sy =
        y + sin(a + halfAngle) * radius1;

      vertex(sx, sy);

    }

    endShape(CLOSE);

  }


  // =====================================================
  // NOMBRE
  // =====================================================

  String getShortName(int index) {

    return characters[index];

  }

}
