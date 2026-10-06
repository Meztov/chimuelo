/**
 * EL ORÁCULO DE LOS CUENTOS
 * --------------------------
 *
 * PERSONAJE + ACCIÓN + SITUACIÓN
 *              +
 *          VOZ DEL NIÑO
 *
 * Comunicación:
 * Python + MediaPipe -> UDP -> Processing
 * Python + Voz       -> UDP -> Processing
 *
 * Gesto:
 * Pinch = lanzar dodecaedro
 *
 * Voz:
 * Niño habla -> Python -> UDP -> Processing
 *
 * Archivo:
 * cuento.txt
 */

import hypermedia.net.*;
import ddf.minim.*;


// =====================================================
// OBJETOS GLOBALES
// =====================================================

UDP udp;
TrackingDataManager dataManager;

CharacterDice characterDice;
VerbDice verbDice;
SituationDice situationDice;


// =====================================================
// MANO
// =====================================================

PVector handPos = new PVector(-1, -1);

boolean isPinching = false;
boolean pinchStarted = false;


// =====================================================
// CUENTO
// =====================================================

String cuento = "";
String ultimoTexto = "";


// =====================================================
// POSICIONES DE LA INTERFAZ
// =====================================================

float diceY;
float resultY;

float characterX;
float verbX;
float situationX;


// =====================================================
// SETUP
// =====================================================

void setup() {

  size(1000, 750, P3D);

  pixelDensity(1);


  // -----------------------------------------------
  // Posiciones generales
  // -----------------------------------------------

  characterX = width * 0.20;
  verbX = width * 0.50;
  situationX = width * 0.80;

  diceY = height * 0.46;
  resultY = height * 0.70;


  // -----------------------------------------------
  // Datos provenientes de Python
  // -----------------------------------------------

  dataManager = new TrackingDataManager();


  // -----------------------------------------------
  // DADO DE PERSONAJES
  // -----------------------------------------------

  characterDice = new CharacterDice(
    characterX,
    diceY,
    170
  );


  // -----------------------------------------------
  // DADO DE ACCIONES
  // -----------------------------------------------

  verbDice = new VerbDice(
    verbX,
    diceY,
    170
  );


  // -----------------------------------------------
  // DADO DE SITUACIONES
  // -----------------------------------------------

  situationDice = new SituationDice(
    situationX,
    diceY,
    170
  );


  // -----------------------------------------------
  // UDP
  // -----------------------------------------------

  try {

    udp = new UDP(
      this,
      5005
    );

    udp.listen(true);

    println("----------------------------------");
    println(" EL ORÁCULO DE LOS CUENTOS");
    println("----------------------------------");
    println("UDP escuchando en puerto 5005");
    println("Esperando MediaPipe...");
    println("Esperando voz...");
    println("----------------------------------");

  }

  catch(Exception e) {

    println("ERROR iniciando UDP:");
    println(e.getMessage());

    exit();
  }
}


// =====================================================
// DRAW
// =====================================================

void draw() {

  background(18, 14, 35);

  drawBackground();


  // -----------------------------------------------
  // Actualizar dados
  // -----------------------------------------------

  characterDice.update();
  verbDice.update();
  situationDice.update();


  // -----------------------------------------------
  // Detectar mano
  // -----------------------------------------------

  if (
    handPos.x >= 0 &&
    handPos.y >= 0
    ) {

    characterDice.checkHand(handPos);
    verbDice.checkHand(handPos);
    situationDice.checkHand(handPos);
  }


  // -----------------------------------------------
  // Mostrar dados
  // -----------------------------------------------

  characterDice.display();
  verbDice.display();
  situationDice.display();


  // -----------------------------------------------
  // Interfaz
  // -----------------------------------------------

  drawTitle();

  drawLabels();

  drawResults();

  drawStory();

  drawInstructions();

  drawHandCursor();
}


// =====================================================
// FONDO
// =====================================================

void drawBackground() {

  pushMatrix();

  hint(DISABLE_DEPTH_TEST);

  for (int i = 0; i < 80; i++) {

    float x = (i * 83) % width;
    float y = (i * 47) % height;

    float s = 1 + (i % 3);

    noStroke();

    fill(
      255,
      255,
      255,
      90
    );

    ellipse(
      x,
      y,
      s,
      s
    );
  }

  hint(ENABLE_DEPTH_TEST);

  popMatrix();
}


// =====================================================
// TÍTULO
// =====================================================

void drawTitle() {

  hint(DISABLE_DEPTH_TEST);

  textAlign(CENTER, CENTER);

  fill(255);

  textSize(32);

  text(
    "EL ORÁCULO DE LOS CUENTOS",
    width/2,
    height * 0.065
  );


  fill(
    220,
    210,
    255
  );

  textSize(18);

  text(
    "PERSONAJE  •  ACCIÓN  •  SITUACIÓN",
    width/2,
    height * 0.105
  );

  hint(ENABLE_DEPTH_TEST);
}


// =====================================================
// ETIQUETAS DE LOS DADOS
// =====================================================

void drawLabels() {

  hint(DISABLE_DEPTH_TEST);

  textAlign(CENTER, CENTER);

  textSize(17);

  fill(
    255,
    230,
    120
  );


  text(
    "PERSONAJE",
    characterX,
    resultY - 28
  );


  text(
    "ACCIÓN",
    verbX,
    resultY - 28
  );


  text(
    "SITUACIÓN",
    situationX,
    resultY - 28
  );


  hint(ENABLE_DEPTH_TEST);
}


// =====================================================
// RESULTADOS
// =====================================================

void drawResults() {

  hint(DISABLE_DEPTH_TEST);

  textAlign(CENTER, CENTER);


  // -----------------------------------------------
  // PERSONAJE
  // -----------------------------------------------

  if (characterDice.hasResult) {

    drawResultText(
      characterDice.getSelectedCharacter(),
      characterX,
      resultY
    );
  }


  // -----------------------------------------------
  // ACCIÓN
  // -----------------------------------------------

  if (verbDice.hasResult) {

    drawResultText(
      verbDice.getSelectedVerb(),
      verbX,
      resultY
    );
  }


  // -----------------------------------------------
  // SITUACIÓN
  // -----------------------------------------------

  if (situationDice.hasResult) {

    drawResultText(
      situationDice.getSelectedSituation(),
      situationX,
      resultY
    );
  }


  hint(ENABLE_DEPTH_TEST);
}


// =====================================================
// TEXTO DE RESULTADO
// =====================================================

void drawResultText(
  String texto,
  float x,
  float y
  ) {

  if (texto == null) {
    return;
  }

  texto = texto.trim();

  if (texto.equals("")) {
    return;
  }


  fill(255);

  // Tamaño máximo

  float tamano = 25;


  // Reducir si el texto es largo

  if (texto.length() > 15) {
    tamano = 22;
  }

  if (texto.length() > 20) {
    tamano = 19;
  }

  if (texto.length() > 26) {
    tamano = 17;
  }


  textSize(tamano);

  text(
    texto,
    x,
    y,
    width * 0.25,
    45
  );
}


// =====================================================
// CUENTO
// =====================================================

void drawStory() {

  hint(DISABLE_DEPTH_TEST);


  // -----------------------------------------------
  // Dimensiones del panel
  // -----------------------------------------------

  float panelX = width * 0.10;
  float panelY = height * 0.77;

  float panelW = width * 0.80;
  float panelH = height * 0.15;


  // -----------------------------------------------
  // Panel
  // -----------------------------------------------

  noStroke();

  fill(
    35,
    27,
    60,
    240
  );

  rect(
    panelX,
    panelY,
    panelW,
    panelH,
    18
  );


  // -----------------------------------------------
  // Título
  // -----------------------------------------------

  fill(
    255,
    230,
    120
  );

  textAlign(
    CENTER,
    CENTER
  );

  textSize(19);

  text(
    "✨ TU CUENTO ✨",
    width/2,
    panelY + 22
  );


  // -----------------------------------------------
  // Texto
  // -----------------------------------------------

  textAlign(
    LEFT,
    TOP
  );

  textSize(17);


  if (cuento.equals("")) {

    fill(
      200,
      190,
      220
    );

    text(
      "🎤 Habla para comenzar tu historia...",
      panelX + 25,
      panelY + 48,
      panelW - 50,
      panelH - 55
    );

  }

  else {

    fill(255);

    text(
      cuento,
      panelX + 25,
      panelY + 48,
      panelW - 50,
      panelH - 55
    );
  }


  hint(ENABLE_DEPTH_TEST);
}


// =====================================================
// AGREGAR TEXTO AL CUENTO
// =====================================================

void agregarTexto(
  String texto
  ) {

  if (texto == null) {
    return;
  }


  texto = texto.trim();


  if (texto.equals("")) {
    return;
  }


  // -----------------------------------------------
  // Evitar duplicados
  // -----------------------------------------------

  if (texto.equals(ultimoTexto)) {
    return;
  }


  ultimoTexto = texto;


  // -----------------------------------------------
  // Agregar al cuento
  // -----------------------------------------------

  if (cuento.equals("")) {

    cuento = texto;

  }

  else {

    cuento += " " + texto;
  }


  // -----------------------------------------------
  // Guardar inmediatamente
  // -----------------------------------------------

  guardarCuento();


  println("----------------------------------");
  println("NUEVO FRAGMENTO:");
  println(texto);
  println();
  println("CUENTO:");
  println(cuento);
  println("----------------------------------");
}


// =====================================================
// GUARDAR CUENTO
// =====================================================

void guardarCuento() {

  String[] lineas = {

    "EL ORÁCULO DE LOS CUENTOS",

    "",

    "PERSONAJE: " +
    (characterDice.hasResult ?
    characterDice.getSelectedCharacter() :
    ""),

    "ACCIÓN: " +
    (verbDice.hasResult ?
    verbDice.getSelectedVerb() :
    ""),

    "SITUACIÓN: " +
    (situationDice.hasResult ?
    situationDice.getSelectedSituation() :
    ""),

    "",

    "CUENTO:",

    "",

    cuento
  };


  saveStrings(
    "cuento.txt",
    lineas
  );


  println("💾 Cuento guardado en cuento.txt");
}


// =====================================================
// INSTRUCCIONES
// =====================================================

void drawInstructions() {

  hint(DISABLE_DEPTH_TEST);

  textAlign(
    CENTER,
    CENTER
  );

  fill(255);

  textSize(16);


  if (
    characterDice.isRolling ||
    verbDice.isRolling ||
    situationDice.isRolling
    ) {

    text(
      "¡Lanzando!",
      width/2,
      height * 0.965
    );

  }

  else {

    text(
      "Acerca tu dedo a un dado y haz PINCH para lanzarlo",
      width/2,
      height * 0.965
    );
  }


  hint(ENABLE_DEPTH_TEST);
}


// =====================================================
// CURSOR DE MANO
// =====================================================

void drawHandCursor() {

  if (
    handPos.x < 0 ||
    handPos.y < 0
    ) {

    return;
  }


  hint(DISABLE_DEPTH_TEST);

  noFill();


  if (isPinching) {

    stroke(
      255,
      210,
      70
    );

    strokeWeight(4);

    ellipse(
      handPos.x,
      handPos.y,
      38,
      38
    );

  }

  else {

    stroke(
      255,
      255,
      255,
      180
    );

    strokeWeight(2);

    ellipse(
      handPos.x,
      handPos.y,
      25,
      25
    );
  }


  hint(ENABLE_DEPTH_TEST);
}


// =====================================================
// UDP
// =====================================================

void receive(
  byte[] data,
  String ip,
  int port
  ) {

  try {


    // ---------------------------------------------
    // Convertir mensaje
    // ---------------------------------------------

    String message =
      new String(
      data,
      "UTF-8"
      );


    JSONObject json =
      parseJSONObject(message);


    if (json == null) {
      return;
    }


    // =================================================
    // TEXTO DE VOZ
    // =================================================

    if (json.hasKey("texto")) {

      String texto =
        json.getString("texto");


      if (
        texto != null &&
        !texto.equals("")
        ) {

        agregarTexto(texto);
      }
    }


    // =================================================
    // DATOS DE MEDIAPIPE
    // =================================================

    dataManager.load(json);


    // ---------------------------------------------
    // Coordenadas
    // ---------------------------------------------

    PVector rawPos =
      dataManager.getVec2(
      "index_finger_coords"
      );


    if (rawPos != null) {

      handPos.x =
        map(
        rawPos.x,
        0,
        1,
        0,
        width
        );


      handPos.y =
        map(
        rawPos.y,
        0,
        1,
        0,
        height
        );
    }


    // ---------------------------------------------
    // Pinch
    // ---------------------------------------------

    boolean currentPinchState =
      dataManager.getBool(
      "is_pinching"
      );


    if (
      currentPinchState &&
      !isPinching
      ) {

      pinchStarted = true;

    }

    else {

      pinchStarted = false;
    }


    isPinching =
      currentPinchState;


    // ---------------------------------------------
    // Lanzar dados
    // ---------------------------------------------

    if (pinchStarted) {

      characterDice.handlePinch(
        handPos
      );

      verbDice.handlePinch(
        handPos
      );

      situationDice.handlePinch(
        handPos
      );
    }
  }


  catch(Exception e) {

    println(
      "Error procesando UDP: "
      + e.getMessage()
    );
  }
}


// =====================================================
// STOP
// =====================================================

void stop() {

  if (udp != null) {

    udp.close();
  }

  super.stop();
}
