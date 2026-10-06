/**
 * Simon Says - Juego Interactivo con MediaPipe
 * --------------------------------------------
 * Archivo Principal
 * Autor: Tomás Santiago
 * Este es el sketch principal que inicializa y conecta todos los módulos del juego.
 * Gestiona la comunicación UDP para recibir los datos de seguimiento de la mano
 * desde el script de Python.
 */

import hypermedia.net.*; // Librería para UDP
import ddf.minim.*;      // Librería para el sonido

// --- OBJETOS GLOBALES ---
UDP udp;
TrackingDataManager dataManager;
GameLogic game;
Visuals visuals;
SoundManager soundManager;

// Coordenadas del dedo y estado del gesto de pellizco
PVector handPos = new PVector(-1, -1);
boolean isPinching = false;
boolean pinchStarted = false; // Para detectar un solo clic

void setup() {
  size(800, 800, P2D);
  pixelDensity(1);
  // Inicialización de los módulos
  dataManager = new TrackingDataManager();
  game = new GameLogic();
  visuals = new Visuals(game);
  soundManager = new SoundManager(this);
  
  // Configuración del cliente UDP para recibir datos en el puerto 5005
  try {
    udp = new UDP(this, 5005);
    udp.listen(true);
    println(">>> Escuchando en el puerto 5005 para datos de MediaPipe...");
  }
  catch(Exception e) {
    println("!!! Error al iniciar el servidor UDP: " + e.getMessage());
    println("!!! Asegúrate de que el puerto 5005 no esté en uso.");
    exit();
  }
}

void draw() {
  background(25); // Fondo oscuro
  
  // Actualizar la lógica y los visuales en cada frame
  game.update();
  visuals.updateHandData(handPos, isPinching, pinchStarted);
  visuals.display();
}

/**
 * Función que se llama automáticamente cuando se recibe un paquete UDP.
 * Procesa los datos JSON del script de Python.
 */
void receive(byte[] data, String ip, int port) {
  String message = new String(data);
  try {
    JSONObject json = parseJSONObject(message);
    dataManager.load(json);

    // Actualizar coordenadas y estado de pellizco
    PVector rawPos = dataManager.getVec2("index_finger_coords");
    if (rawPos != null) {
      // Mapear coordenadas normalizadas (0-1) al tamaño de la pantalla
      handPos.x = map(rawPos.x, 0, 1, 0, width);
      handPos.y = map(rawPos.y, 0, 1, 0, height);
    }
    
    boolean currentPinchState = dataManager.getBool("is_pinching");
    
    // Detectar el inicio del gesto de "pinch" (un solo clic)
    if (currentPinchState && !isPinching) {
      pinchStarted = true;
    } else {
      pinchStarted = false;
    }
    isPinching = currentPinchState;

    // Pasar la información del clic al juego
    if (pinchStarted) {
      game.handleClick(handPos);
    }
    
  } catch (Exception e) {
    //println("Error al parsear JSON: " + e.getMessage());
  }
}

// Asegurarse de cerrar los recursos de sonido al salir
void stop() {
  soundManager.stop();
  super.stop();
}
