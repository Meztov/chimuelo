/**
 * Módulo de Sonido
 * -----------------
 * Carga y controla la reproducción de todos los efectos de sonido del juego.
 * Utiliza la librería Minim.
 * * IMPORTANTE:
 * Debes crear una carpeta llamada "data" dentro de tu sketch de Processing
 * y colocar los siguientes archivos de sonido en formato WAV Y MP3:
 * - color_0.wav (para el botón rojo)
 * - color_1.wav (para el botón azul)
 * - color_2.wav (para el botón verde)
 * - color_3.wav (para el botón amarillo)
 * - win.mp3     (sonido al ganar el juego)
 * - lose.mp3   (sonido al perder)
 */

import ddf.minim.*;

class SoundManager {
  Minim minim;
  
  AudioPlayer[] colorSounds = new AudioPlayer[4];
  AudioPlayer winSound;
  AudioPlayer loseSound;

  SoundManager(PApplet parent) {
    minim = new Minim(parent);
    
    // Cargar sonidos
    try {
      println("Cargando archivos de sonido...");
      colorSounds[0] = minim.loadFile("color_0.wav");
      colorSounds[1] = minim.loadFile("color_1.wav");
      colorSounds[2] = minim.loadFile("color_2.wav");
      colorSounds[3] = minim.loadFile("color_3.wav");
      winSound = minim.loadFile("win.mp3");
      loseSound = minim.loadFile("lose.mp3");
      println("Sonidos cargados correctamente.");
    } catch(Exception e) {
        println("!!! Error al cargar los sonidos: " + e.getMessage());
        println("!!! Asegúrate de tener la carpeta 'data' con los archivos .wav necesarios en el sketch.");
    }
  }

  void playColorSound(int index) {
    if (index >= 0 && index < colorSounds.length && colorSounds[index] != null) {
      colorSounds[index].rewind();
      colorSounds[index].play();
    }
  }

  void playWinSound() {
    if (winSound != null) {
      winSound.rewind();
      winSound.play();
    }
  }

  void playLoseSound() {
    if (loseSound != null) {
      loseSound.rewind();
      loseSound.play();
    }
  }
  
  // Liberar recursos al cerrar la aplicación
  void stop() {
    minim.stop();
  }
}
