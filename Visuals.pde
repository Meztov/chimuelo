/**
 * Módulo de Visuales
 * -------------------
 * Dibuja todos los elementos gráficos del juego: botones, texto,
 * animaciones y retroalimentación del cursor.
 */

class Visuals {
  GameLogic game; // Referencia a la lógica para saber qué dibujar

  // Colores del juego
  color[] buttonColors = {
    #FF3B30, // Rojo
    #007AFF, // Azul
    #34C759, // Verde
    #FFCC00  // Amarillo
  };

  color[] highlightColors = {
    #FF9A94,
    #80BFFF,
    #9BECB0,
    #FFE680
  };

  // Posiciones y tamaños de los botones
  Rect[] buttons = new Rect[4];
  
  // Para la animación de resaltado de botones
  int highlightedButton = -1;
  long highlightStartTime;
  int highlightDuration;
  
  // Para la retroalimentación del cursor
  PVector handPos_v;
  boolean isPinching_v;
  boolean pinchStarted_v;
  ArrayList<ClickFeedback> clickFeedbacks = new ArrayList<ClickFeedback>();

  // Fuentes
  PFont titleFont;
  PFont messageFont;

  Visuals(GameLogic g) {
    this.game = g;
    
    // Configura las áreas de los botones
    float padding = 40;
    float buttonSize = (width - 3 * padding) / 2;
    buttons[0] = new Rect(padding, padding, buttonSize, buttonSize); // Rojo (arriba-izq)
    buttons[1] = new Rect(padding * 2 + buttonSize, padding, buttonSize, buttonSize); // Azul (arriba-der)
    buttons[2] = new Rect(padding, padding * 2 + buttonSize, buttonSize, buttonSize); // Verde (abajo-izq)
    buttons[3] = new Rect(padding * 2 + buttonSize, padding * 2 + buttonSize, buttonSize, buttonSize); // Amarillo (abajo-der)
    
    titleFont = loadFont("AlteHaasGrotesk_Bold-60.vlw");
    messageFont = loadFont("AlteHaasGrotesk-32.vlw");
  }

  void updateHandData(PVector pos, boolean pinching, boolean started) {
      this.handPos_v = pos;
      this.isPinching_v = pinching;
      this.pinchStarted_v = started;
  }

  void display() {
    // Dibujar elementos comunes
    drawButtons();
    drawCursor();
    
    // Dibujar pantalla según el estado del juego
    switch(game.currentState) {
      case START_SCREEN:
        drawMessageScreen("Simón Dice", "Haz un pellizco para empezar");
        break;
      case SHOWING_SEQUENCE:
        drawGameInfo("Observa...");
        break;
      case PLAYER_TURN:
        drawGameInfo("Tu turno...");
        break;
      case GAME_OVER:
        drawMessageScreen("¡Juego Terminado!", "Pellizco para reintentar");
        break;
      case GAME_WON:
        drawMessageScreen("¡GANASTE!", "Pellizco para volver a jugar");
        break;
    }
    
    // Actualizar y dibujar animaciones de clic
    for (int i = clickFeedbacks.size() - 1; i >= 0; i--) {
        ClickFeedback cf = clickFeedbacks.get(i);
        cf.update();
        cf.display();
        if (cf.isDone()) {
            clickFeedbacks.remove(i);
        }
    }
  }

  void drawButtons() {
    noStroke();
    for (int i = 0; i < 4; i++) {
      if (highlightedButton == i && millis() - highlightStartTime < highlightDuration) {
        fill(highlightColors[i]);
      } else {
        fill(buttonColors[i]);
      }
      rect(buttons[i].x, buttons[i].y, buttons[i].w, buttons[i].h, 20); // Rectángulos con bordes redondeados
    }
  }

  void drawCursor() {
    if (handPos_v.x > 0) {
      stroke(255);
      strokeWeight(3);
      if (isPinching_v) {
        fill(255, 255, 255, 180);
      } else {
        noFill();
      }
      ellipse(handPos_v.x, handPos_v.y, 40, 40);
    }
  }

  void drawGameInfo(String message) {
      textAlign(CENTER, CENTER);
      textFont(messageFont);
      fill(255);
      text("Nivel: " + game.currentLevel, width / 2, height - 50);
      text(message, width / 2, height / 2);
  }

  void drawMessageScreen(String title, String subtitle) {
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    
    textAlign(CENTER, CENTER);
    fill(255);
    
    textFont(titleFont);
    text(title, width / 2, height / 2 - 40);
    
    textFont(messageFont);
    text(subtitle, width / 2, height / 2 + 40);
  }

  void highlightButton(int index, int duration) {
    highlightedButton = index;
    highlightDuration = duration;
    highlightStartTime = millis();
  }
  
  void showClickFeedback(PVector pos) {
      clickFeedbacks.add(new ClickFeedback(pos));
  }

  int getButtonAt(PVector pos) {
    for (int i = 0; i < 4; i++) {
      if (buttons[i].contains(pos.x, pos.y)) {
        return i;
      }
    }
    return -1; // Ningún botón presionado
  }
}

// Clase auxiliar para la geometría de los botones
class Rect {
  float x, y, w, h;
  Rect(float x, float y, float w, float h) {
    this.x = x; this.y = y; this.w = w; this.h = h;
  }
  boolean contains(float px, float py) {
    return px >= x && px <= x + w && py >= y && py <= y + h;
  }
}

// Clase para la animación de feedback al hacer clic
class ClickFeedback {
    PVector pos;
    float radius;
    float maxRadius = 60;
    float alpha = 255;

    ClickFeedback(PVector pos) {
        this.pos = pos.copy();
        this.radius = 0;
    }

    void update() {
        radius += 4;
        alpha -= 10;
    }

    void display() {
        noFill();
        stroke(255, alpha);
        strokeWeight(4);
        ellipse(pos.x, pos.y, radius, radius);
    }

    boolean isDone() {
        return alpha <= 0;
    }
}
