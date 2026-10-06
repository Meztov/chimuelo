/**
 * Lógica del Juego Simón Dice
 * ----------------------------
 * Este módulo maneja el estado del juego, las secuencias y la puntuación.
 */

// Enumeración para definir los posibles estados del juego
enum GameState {
  START_SCREEN,      // Pantalla de inicio
  SHOWING_SEQUENCE,  // El juego muestra la secuencia de colores
  PLAYER_TURN,       // El jugador debe repetir la secuencia
  GAME_OVER,         // El jugador ha perdido
  GAME_WON           // El jugador ha ganado
}

class GameLogic {
  final int MAX_SEQUENCE = 10; // Longitud máxima de la secuencia para ganar
  
  GameState currentState;
  ArrayList<Integer> sequence; // Almacena la secuencia de colores (0-3)
  
  int currentLevel;      // Nivel actual (longitud de la secuencia)
  int playerIndex;       // Índice del color que el jugador debe presionar
  int sequenceDisplayIndex; // Índice del color que se está mostrando
  
  long lastActionTime;   // Para controlar el tiempo entre acciones
  int sequenceDelay = 700; // Milisegundos entre cada color mostrado
  int postSequenceDelay = 300; // Pequeña pausa después de mostrar la secuencia

  GameLogic() {
    startNewGame();
  }

  void startNewGame() {
    currentState = GameState.START_SCREEN;
    sequence = new ArrayList<Integer>();
    currentLevel = 0;
  }
  
  void beginSequence() {
      currentState = GameState.SHOWING_SEQUENCE;
      playerIndex = 0;
      sequenceDisplayIndex = 0;
      int newColor = floor(random(4));
      sequence.add(newColor);
      currentLevel = sequence.size();
      lastActionTime = millis();
      println("Iniciando Nivel " + currentLevel + ". Secuencia: " + sequence);
  }

  void update() {
    if (currentState != GameState.SHOWING_SEQUENCE) {
      return;
    }

    // Lógica para mostrar la secuencia de colores de forma temporizada
    if (millis() - lastActionTime > sequenceDelay) {
      if (sequenceDisplayIndex < sequence.size()) {
        int colorToShow = sequence.get(sequenceDisplayIndex);
        soundManager.playColorSound(colorToShow);
        visuals.highlightButton(colorToShow, 400); // Resalta el botón por 400ms
        sequenceDisplayIndex++;
        lastActionTime = millis();
      } else {
        // La secuencia ha terminado de mostrarse
        currentState = GameState.PLAYER_TURN;
        println("Turno del jugador.");
      }
    }
  }

  void handleClick(PVector clickPos) {
    switch (currentState) {
      case START_SCREEN:
      case GAME_OVER:
      case GAME_WON:
        startNewGame();
        beginSequence();
        break;
      case SHOWING_SEQUENCE:
        break;        
      case PLAYER_TURN:
        int clickedButton = visuals.getButtonAt(clickPos);
        if (clickedButton != -1) {
          soundManager.playColorSound(clickedButton);
          visuals.showClickFeedback(clickPos); // Feedback visual de clic
          
          if (clickedButton == sequence.get(playerIndex)) {
            // Acierto
            playerIndex++;
            if (playerIndex >= sequence.size()) {
              // Nivel completado
              if (currentLevel >= MAX_SEQUENCE) {
                // ¡Juego ganado!
                currentState = GameState.GAME_WON;
                soundManager.playWinSound();
                println("¡Has ganado!");
              } else {
                // Pasa al siguiente nivel
                println("Nivel " + currentLevel + " completado.");
                delay(1000); // Pausa antes de la siguiente secuencia
                beginSequence();
              }
            }
          } else {
            // Error
            currentState = GameState.GAME_OVER;
            soundManager.playLoseSound();
            println("¡Error! Juego terminado. Secuencia era: " + sequence.get(playerIndex) + " y presionaste: " + clickedButton);
          }
        }
        break;
    }
  }
}
