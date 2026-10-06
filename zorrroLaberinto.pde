import hypermedia.net.*;
import java.util.HashMap;


// =====================================================
// VARIABLES PRINCIPALES
// =====================================================

UDP udp;

TrackingData dataManager;
GameLogic game;
Maze maze;
Fox fox;
Rose rose;


// Posición del dedo índice
PVector handPos = new PVector(-1, -1);


// Estado del pinch
boolean isPinching = false;
boolean pinchStarted = false;


// =====================================================
// SETUP
// =====================================================

void setup() {

  size(800, 800);

  frameRate(60);

  // Crear objetos
  dataManager = new TrackingData();

  maze = new Maze();

  fox = new Fox(
    maze.startX,
    maze.startY
  );

  rose = new Rose(
    maze.goalX,
    maze.goalY
  );

  game = new GameLogic();


  // =================================================
  // UDP
  // =================================================

  udp = new UDP(this, 5005);

  udp.listen(true);


  println("================================");
  println("     EL ZORRO Y LA ROSA");
  println("================================");
  println("UDP escuchando en puerto 5005");
  println("Esperando datos de Python...");
}


// =====================================================
// DRAW
// =====================================================

void draw() {

  background(245, 235, 210);

  game.update();

  game.draw();

  drawConnectionIndicator();
}


// =====================================================
// RECIBIR DATOS DE PYTHON
// =====================================================

void receive(
  byte[] data,
  String ip,
  int port
  ) {

  // Convertir datos UDP a texto
  String message = new String(data);


  // Convertir JSON
  JSONObject json =
    parseJSONObject(message);


  // Si el JSON no es válido
  if (json == null) {

    return;
  }


  // =================================================
  // CARGAR DATOS
  // =================================================

  dataManager.load(json);


  // =================================================
  // OBTENER POSICIÓN DEL ÍNDICE
  // =================================================

  PVector coords =
    dataManager.getVec2(
    "index_finger_coords"
    );


  if (coords != null) {

    handPos.x =
      coords.x * width;

    handPos.y =
      coords.y * height;
  }


  // =================================================
  // OBTENER PINCH
  // =================================================

  boolean currentPinching =
    dataManager.getBool(
    "is_pinching"
    );


  // Detectar solamente cuando
  // comienza el pinch
  pinchStarted =
    currentPinching &&
    !isPinching;


  // Guardar estado actual
  isPinching =
    currentPinching;


  // =================================================
  // PINCH = BOTÓN
  // =================================================

  if (pinchStarted) {

    game.handlePinch(handPos);
  }
}


// =====================================================
// INDICADOR DE CONEXIÓN
// =====================================================

void drawConnectionIndicator() {

  boolean connected =
    handPos.x >= 0 &&
    handPos.y >= 0;


  noStroke();


  if (connected) {

    fill(70, 180, 90);

  } else {

    fill(200, 70, 70);
  }


  ellipse(
    width - 30,
    30,
    15,
    15
  );


  fill(60);

  textAlign(
    RIGHT,
    CENTER
    );

  textSize(13);


  if (connected) {

    text(
      "MANO DETECTADA",
      width - 45,
      30
    );

  } else {

    text(
      "ESPERANDO CÁMARA",
      width - 45,
      30
    );
  }
}
