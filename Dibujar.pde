import hypermedia.net.*;

UDP udp;

PVector handPos = new PVector(-1, -1);

boolean isPinching = false;
boolean pinchStarted = false;

int pantalla = 0;

PGraphics lienzo;

int colorActual = 0;
boolean borrador = false;

float grosor = 12;

color[] colores = {
  color(230, 60, 70),
  color(245, 140, 40),
  color(245, 210, 50),
  color(70, 190, 100),
  color(60, 130, 230),
  color(150, 90, 210),
  color(240, 100, 170)
};


void setup() {

  size(1100, 750);

  lienzo = createGraphics(width, height);

  lienzo.beginDraw();
  lienzo.background(255);
  lienzo.endDraw();

  try {

    udp = new UDP(this, 5005);
    udp.listen(true);

    println("UDP iniciado.");

  } catch(Exception e) {

    println("Error iniciando UDP:");
    println(e.getMessage());
  }
}


void draw() {

  if (pantalla == 0) {

    menu();

  } else {

    dibujo();
  }

  cursorMano();
}


// =================================================
// MENU
// =================================================

void menu() {

  background(25, 20, 45);

  textAlign(CENTER, CENTER);

  fill(255);

  textSize(55);

  text(
    "EL JARDÍN DE LOS COLORES",
    width/2,
    150
  );

  fill(220);

  textSize(24);

  text(
    "Haz PINCH para comenzar",
    width/2,
    220
  );


  float bx = width/2;
  float by = height/2;

  float bw = 400;
  float bh = 160;


  boolean sobre =
    handPos.x > bx - bw/2 &&
    handPos.x < bx + bw/2 &&
    handPos.y > by - bh/2 &&
    handPos.y < by + bh/2;


  if (sobre) {

    fill(255, 200, 80);

  } else {

    fill(150, 90, 220);
  }

  noStroke();

  rectMode(CENTER);

  rect(
    bx,
    by,
    bw,
    bh,
    30
  );


  fill(255);

  textSize(45);

  text(
    "DIBUJAR",
    bx,
    by
  );

  rectMode(CORNER);
}


// =================================================
// DIBUJO
// =================================================

void dibujo() {

  background(230);

  image(
    lienzo,
    0,
    0
  );


  // BARRA

  fill(25, 20, 45);

  rect(
    0,
    0,
    width,
    100
  );


  fill(255);

  textAlign(LEFT, CENTER);

  textSize(30);

  text(
    "DIBUJAR",
    35,
    50
  );


  // COLORES

  float inicioX = 350;

  for (int i = 0; i < 7; i++) {

    float x =
      inicioX + i * 70;

    if (
      i == colorActual &&
      !borrador
    ) {

      stroke(255);
      strokeWeight(5);

    } else {

      noStroke();
    }

    fill(colores[i]);

    ellipse(
      x,
      50,
      52,
      52
    );
  }


  // BORRADOR

  float bx =
    inicioX + 7 * 70;

  if (borrador) {

    stroke(255);
    strokeWeight(5);

  } else {

    noStroke();
  }

  fill(245);

  rectMode(CENTER);

  rect(
    bx,
    50,
    60,
    45,
    8
  );

  fill(50);

  textAlign(CENTER, CENTER);

  textSize(15);

  text(
    "BORRAR",
    bx,
    50
  );

  rectMode(CORNER);


  // BOTÓN MENÚ

  noStroke();

  fill(80);

  rect(
    15,
    115,
    150,
    55,
    15
  );

  fill(255);

  textAlign(CENTER, CENTER);

  textSize(20);

  text(
    "← MENÚ",
    90,
    142
  );


  // DIBUJAR

  if (
    isPinching &&
    handPos.y > 180
  ) {

    pintar();
  }
}


// =================================================
// PINTAR
// =================================================

void pintar() {

  lienzo.beginDraw();

  lienzo.strokeWeight(grosor);
  lienzo.strokeCap(ROUND);

  if (borrador) {

    lienzo.stroke(255);

  } else {

    lienzo.stroke(
      colores[colorActual]
    );
  }

  lienzo.point(
    handPos.x,
    handPos.y
  );

  lienzo.endDraw();
}


// =================================================
// CURSOR
// =================================================

void cursorMano() {

  if (
    handPos.x < 0 ||
    handPos.y < 0
  ) {

    return;
  }

  noFill();

  if (isPinching) {

    stroke(255, 200, 50);
    strokeWeight(5);

    ellipse(
      handPos.x,
      handPos.y,
      35,
      35
    );

  } else {

    stroke(255);
    strokeWeight(3);

    ellipse(
      handPos.x,
      handPos.y,
      25,
      25
    );
  }

  noStroke();
}


// =================================================
// UDP
// =================================================

void receive(
  byte[] data,
  String ip,
  int port
) {

  try {

    String mensaje =
      new String(data, "UTF-8");

    JSONObject json =
      parseJSONObject(mensaje);

    if (json == null) {

      return;
    }


    // POSICIÓN

    if (
      json.hasKey(
        "index_finger_coords"
      )
    ) {

      JSONArray posicion =
        json.getJSONArray(
          "index_finger_coords"
        );

      float x =
        posicion.getFloat(0);

      float y =
        posicion.getFloat(1);


      handPos.x =
        map(
          x,
          0,
          1,
          0,
          width
        );

      handPos.y =
        map(
          y,
          0,
          1,
          0,
          height
        );
    }


    // PINCH

    boolean nuevoPinch =
      json.getBoolean(
        "is_pinching",
        false
      );


    pinchStarted =
      nuevoPinch &&
      !isPinching;


    isPinching =
      nuevoPinch;


    // ACCIONES

    if (pinchStarted) {

      procesarPinch();
    }


  } catch(Exception e) {

    println(
      "Error UDP: " +
      e.getMessage()
    );
  }
}


// =================================================
// PINCH
// =================================================

void procesarPinch() {


  // MENU

  if (pantalla == 0) {

    float bx = width/2;
    float by = height/2;

    if (
      handPos.x > bx - 200 &&
      handPos.x < bx + 200 &&
      handPos.y > by - 80 &&
      handPos.y < by + 80
    ) {

      pantalla = 1;
    }

    return;
  }


  // PROGRAMA

  if (pantalla == 1) {


    // MENÚ

    if (
      handPos.x > 15 &&
      handPos.x < 165 &&
      handPos.y > 115 &&
      handPos.y < 170
    ) {

      pantalla = 0;

      return;
    }


    // COLORES

    float inicioX = 350;

    for (int i = 0; i < 7; i++) {

      float x =
        inicioX + i * 70;

      if (
        dist(
          handPos.x,
          handPos.y,
          x,
          50
        ) < 35
      ) {

        colorActual = i;

        borrador = false;

        return;
      }
    }


    // BORRADOR

    float bx =
      inicioX + 7 * 70;

    if (
      dist(
        handPos.x,
        handPos.y,
        bx,
        50
      ) < 40
    ) {

      borrador = true;

      return;
    }
  }
}
