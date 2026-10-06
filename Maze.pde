// =====================================================
// MAZE.PDE
// EL ZORRO Y LA ROSA
// 10 NIVELES - LABERINTO PROCEDURAL
// =====================================================

class Maze {

  ArrayList<Wall> walls;

  int level = 1;

  int COLS;
  int ROWS;

  float CELL;

  float MAZE_X;
  float MAZE_Y;

  float WALL_THICKNESS = 10;

  float startX;
  float startY;

  float goalX;
  float goalY;


  // =====================================================
  // CONSTRUCTOR
  // =====================================================

  Maze() {

    walls = new ArrayList<Wall>();

    setLevel(1);
  }


  // =====================================================
  // CONFIGURAR NIVEL
  // =====================================================

  void setLevel(int newLevel) {

    level = constrain(newLevel, 1, 10);


    // ===================================================
    // CONFIGURACIÓN DE LOS 10 NIVELES
    // ===================================================

    if (level == 1) {

      COLS = 10;
      ROWS = 8;
      CELL = 60;

    } else if (level == 2) {

      COLS = 11;
      ROWS = 8;
      CELL = 58;

    } else if (level == 3) {

      COLS = 12;
      ROWS = 9;
      CELL = 55;

    } else if (level == 4) {

      COLS = 13;
      ROWS = 9;
      CELL = 52;

    } else if (level == 5) {

      COLS = 14;
      ROWS = 10;
      CELL = 49;

    } else if (level == 6) {

      COLS = 15;
      ROWS = 10;
      CELL = 46;

    } else if (level == 7) {

      COLS = 16;
      ROWS = 11;
      CELL = 43;

    } else if (level == 8) {

      COLS = 17;
      ROWS = 11;
      CELL = 41;

    } else if (level == 9) {

      COLS = 18;
      ROWS = 12;
      CELL = 39;

    } else {

      COLS = 19;
      ROWS = 12;
      CELL = 37;
    }


    // ===================================================
    // CENTRAR LABERINTO
    // ===================================================

    float mazeWidth = COLS * CELL;

    MAZE_X = (width - mazeWidth) / 2.0;

    MAZE_Y = 70;


    // ===================================================
    // INICIO
    // ===================================================

    startX = MAZE_X + CELL / 2;

    startY = MAZE_Y + CELL / 2;


    // ===================================================
    // META
    // ===================================================

    goalX =
      MAZE_X +
      (COLS - 1) * CELL +
      CELL / 2;

    goalY =
      MAZE_Y +
      (ROWS - 1) * CELL +
      CELL / 2;


    // ===================================================
    // CREAR LABERINTO NUEVO
    // ===================================================

    createMaze();
  }


  // =====================================================
  // CREAR LABERINTO
  // =====================================================

  void createMaze() {

    walls.clear();


    boolean[][] visited =
      new boolean[COLS][ROWS];


    boolean[][] rightWall =
      new boolean[COLS][ROWS];


    boolean[][] bottomWall =
      new boolean[COLS][ROWS];


    // ===================================================
    // TODAS LAS PAREDES EXISTEN INICIALMENTE
    // ===================================================

    for (int x = 0; x < COLS; x++) {

      for (int y = 0; y < ROWS; y++) {

        rightWall[x][y] = true;

        bottomWall[x][y] = true;
      }
    }


    // ===================================================
    // IMPORTANTE:
    //
    // NO usamos randomSeed().
    //
    // Processing utiliza una semilla diferente
    // para las ejecuciones, por lo que cada vez
    // se genera un laberinto diferente.
    // ===================================================


    // ===================================================
    // GENERAR LABERINTO PRINCIPAL
    // ===================================================

    generateMaze(
      0,
      0,
      visited,
      rightWall,
      bottomWall
    );


    // ===================================================
    // CAMINOS EXTRA
    // ===================================================
    //
    // A partir del nivel 3 quitamos algunas paredes
    // adicionales para crear rutas alternativas.
    //
    // Esto hace que los niveles superiores sean
    // menos predecibles.
    // ===================================================

    if (level >= 3) {

      addExtraPaths(
        rightWall,
        bottomWall
      );
    }


    // ===================================================
    // DIMENSIONES
    // ===================================================

    float mazeWidth =
      COLS * CELL;

    float mazeHeight =
      ROWS * CELL;


    // ===================================================
    // BORDE SUPERIOR
    // ===================================================

    walls.add(
      new Wall(
        MAZE_X,
        MAZE_Y,
        mazeWidth,
        WALL_THICKNESS
      )
    );


    // ===================================================
    // BORDE IZQUIERDO
    // ===================================================

    walls.add(
      new Wall(
        MAZE_X,
        MAZE_Y,
        WALL_THICKNESS,
        mazeHeight
      )
    );


    // ===================================================
    // BORDE DERECHO
    // ===================================================

    walls.add(
      new Wall(
        MAZE_X +
        mazeWidth -
        WALL_THICKNESS,

        MAZE_Y,

        WALL_THICKNESS,

        mazeHeight
      )
    );


    // ===================================================
    // BORDE INFERIOR
    // ===================================================

    walls.add(
      new Wall(
        MAZE_X,

        MAZE_Y +
        mazeHeight -
        WALL_THICKNESS,

        mazeWidth,

        WALL_THICKNESS
      )
    );


    // ===================================================
    // PAREDES INTERNAS
    // ===================================================

    for (int x = 0; x < COLS; x++) {

      for (int y = 0; y < ROWS; y++) {

        float px =
          MAZE_X +
          x * CELL;

        float py =
          MAZE_Y +
          y * CELL;


        // -----------------------------------------------
        // PARED DERECHA
        // -----------------------------------------------

        if (
          x < COLS - 1 &&
          rightWall[x][y]
        ) {

          walls.add(
            new Wall(

              px +
              CELL -
              WALL_THICKNESS / 2,

              py,

              WALL_THICKNESS,

              CELL
            )
          );
        }


        // -----------------------------------------------
        // PARED INFERIOR
        // -----------------------------------------------

        if (
          y < ROWS - 1 &&
          bottomWall[x][y]
        ) {

          walls.add(
            new Wall(

              px,

              py +
              CELL -
              WALL_THICKNESS / 2,

              CELL,

              WALL_THICKNESS
            )
          );
        }
      }
    }
  }


  // =====================================================
  // GENERADOR DFS
  // =====================================================

  void generateMaze(
    int cx,
    int cy,
    boolean[][] visited,
    boolean[][] rightWall,
    boolean[][] bottomWall
  ) {

    visited[cx][cy] = true;


    int[] directions = {
      0,
      1,
      2,
      3
    };


    // ===================================================
    // MEZCLAR DIRECCIONES
    // ===================================================

    for (
      int i = directions.length - 1;
      i > 0;
      i--
    ) {

      int j =
        int(random(i + 1));


      int temp =
        directions[i];

      directions[i] =
        directions[j];

      directions[j] =
        temp;
    }


    // ===================================================
    // EXPLORAR DIRECCIONES
    // ===================================================

    for (
      int i = 0;
      i < directions.length;
      i++
    ) {

      int nx = cx;
      int ny = cy;


      int direction =
        directions[i];


      // Arriba
      if (direction == 0) {
        ny--;
      }


      // Derecha
      if (direction == 1) {
        nx++;
      }


      // Abajo
      if (direction == 2) {
        ny++;
      }


      // Izquierda
      if (direction == 3) {
        nx--;
      }


      // =================================================
      // FUERA DEL LABERINTO
      // =================================================

      if (
        nx < 0 ||
        nx >= COLS ||
        ny < 0 ||
        ny >= ROWS
      ) {

        continue;
      }


      // =================================================
      // CASILLA YA VISITADA
      // =================================================

      if (visited[nx][ny]) {

        continue;
      }


      // =================================================
      // ELIMINAR LA PARED ENTRE LAS DOS CASILLAS
      // =================================================

      if (direction == 0) {

        bottomWall[cx][cy - 1] =
          false;

      } else if (direction == 1) {

        rightWall[cx][cy] =
          false;

      } else if (direction == 2) {

        bottomWall[cx][cy] =
          false;

      } else if (direction == 3) {

        rightWall[cx - 1][cy] =
          false;
      }


      // =================================================
      // CONTINUAR RECORRIDO
      // =================================================

      generateMaze(
        nx,
        ny,
        visited,
        rightWall,
        bottomWall
      );
    }
  }


  // =====================================================
  // CAMINOS EXTRA
  // =====================================================

  void addExtraPaths(
    boolean[][] rightWall,
    boolean[][] bottomWall
  ) {

    // Más caminos conforme aumenta el nivel

    int amount =
      level - 1;


    for (
      int i = 0;
      i < amount;
      i++
    ) {

      int x =
        int(random(COLS));

      int y =
        int(random(ROWS));


      boolean horizontal =
        random(1) < 0.5;


      // -----------------------------------------------
      // CAMINO HORIZONTAL
      // -----------------------------------------------

      if (
        horizontal &&
        x < COLS - 1
      ) {

        rightWall[x][y] =
          false;
      }


      // -----------------------------------------------
      // CAMINO VERTICAL
      // -----------------------------------------------

      else if (
        !horizontal &&
        y < ROWS - 1
      ) {

        bottomWall[x][y] =
          false;
      }
    }
  }


  // =====================================================
  // DIBUJAR
  // =====================================================

  void draw() {

    float mazeWidth =
      COLS * CELL;

    float mazeHeight =
      ROWS * CELL;


    // ===================================================
    // FONDO
    // ===================================================

    noStroke();

    fill(
      255,
      246,
      220
    );

    rect(
      MAZE_X,
      MAZE_Y,
      mazeWidth,
      mazeHeight,
      15
    );


    // ===================================================
    // PISO
    // ===================================================

    fill(
      238,
      218,
      176
    );

    rect(
      MAZE_X +
      WALL_THICKNESS,

      MAZE_Y +
      WALL_THICKNESS,

      mazeWidth -
      WALL_THICKNESS * 2,

      mazeHeight -
      WALL_THICKNESS * 2
    );


    // ===================================================
    // CUADRÍCULA
    // ===================================================

    stroke(
      225,
      201,
      155,
      45
    );

    strokeWeight(1);


    for (
      int x = 0;
      x <= COLS;
      x++
    ) {

      line(

        MAZE_X +
        x * CELL,

        MAZE_Y,

        MAZE_X +
        x * CELL,

        MAZE_Y +
        mazeHeight
      );
    }


    for (
      int y = 0;
      y <= ROWS;
      y++
    ) {

      line(

        MAZE_X,

        MAZE_Y +
        y * CELL,

        MAZE_X +
        mazeWidth,

        MAZE_Y +
        y * CELL
      );
    }


    // ===================================================
    // PAREDES
    // ===================================================

    for (
      Wall wall : walls
    ) {

      wall.draw();
    }


    // ===================================================
    // INICIO
    // ===================================================

    noStroke();

    fill(
      80,
      180,
      110,
      75
    );

    ellipse(
      startX,
      startY,
      38,
      38
    );

    fill(
      70,
      150,
      90
    );

    ellipse(
      startX,
      startY,
      9,
      9
    );


    // ===================================================
    // META
    // ===================================================

    fill(
      245,
      190,
      65,
      65
    );

    ellipse(
      goalX,
      goalY,
      46,
      46
    );

    fill(
      245,
      175,
      45
    );

    ellipse(
      goalX,
      goalY,
      14,
      14
    );
  }


  // =====================================================
  // COLISIÓN
  // =====================================================

  boolean collides(
    float x,
    float y,
    float radius
  ) {

    for (
      Wall wall : walls
    ) {

      if (
        circleRectCollision(
          x,
          y,
          radius,
          wall
        )
      ) {

        return true;
      }
    }


    return false;
  }


  // =====================================================
  // CÍRCULO VS RECTÁNGULO
  // =====================================================

  boolean circleRectCollision(
    float cx,
    float cy,
    float radius,
    Wall r
  ) {

    float closestX =
      constrain(
        cx,
        r.x,
        r.x + r.w
      );


    float closestY =
      constrain(
        cy,
        r.y,
        r.y + r.h
      );


    float distanceX =
      cx - closestX;


    float distanceY =
      cy - closestY;


    float distanceSquared =
      distanceX * distanceX +
      distanceY * distanceY;


    return distanceSquared <
      radius * radius;
  }
}



// =====================================================
// WALL
// =====================================================

class Wall {

  float x;
  float y;

  float w;
  float h;


  Wall(
    float x,
    float y,
    float w,
    float h
  ) {

    this.x = x;
    this.y = y;

    this.w = w;
    this.h = h;
  }


  // =====================================================
  // DIBUJAR PARED
  // =====================================================

  void draw() {

    noStroke();


    // Sombra
    fill(
      150,
      110,
      70,
      85
    );

    rect(
      x + 4,
      y + 5,
      w,
      h,
      4
    );


    // Pared
    fill(
      105,
      75,
      55
    );

    rect(
      x,
      y,
      w,
      h,
      4
    );


    // Borde superior
    fill(
      150,
      115,
      80
    );

    rect(
      x,
      y,
      w,
      min(5, h),
      4
    );
  }
}
