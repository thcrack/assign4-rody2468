PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg,  cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage lifeImg;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;
int q;
int a;
int w;
int []hole1 =new int [24];
int c;
int []hole2 =new int [24];

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth = new int [8] [24] ;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;



float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

void setup() {
  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  lifeImg = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");

  soilEmpty = loadImage("img/soils/soilEmpty.png");

  // Load soil images used in assign3 if you don't plan to finish requirement #6
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");

  // Load PImage[][] soils
  soils = new PImage[6][5];
  for(int i = 0; i < soils.length; i++){
    for(int j = 0; j < soils[i].length; j++){
      soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
    }
  }

  // Load PImage[][] stones
  stones = new PImage[2][5];
  for(int i = 0; i < stones.length; i++){
    for(int j = 0; j < stones[i].length; j++){
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
  }

  // Initialize player
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealth = 2;

  // Initialize soilHealth
  soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for(int i = 0; i < soilHealth.length; i++){
    for (int j = 0; j < soilHealth[i].length; j++) {
       // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;
    }
  }
     for(int a=1; a<24 ; a++){
       c = floor(random(0, 2));
       if(c == 0){
         hole1[a] = floor(random(0, 8));
         hole2[a] = hole1[a];
       }
       else{
         hole2[a] = floor(random(0, 8));
         hole1[a] = floor(random(0, 8));
       }
     }

  


  // Initialize soidiers and their position

  // Initialize cabbages and their position
  
  
     
  
  cabbageX = new float [6];
  cabbageY = new float [6];
  soldierX = new float [6];
  soldierY = new float [6];
  
   for(int i=0;i<6;i++){
      cabbageX[i] = floor(random(0,8));
      cabbageY[i] = floor(random(0,4));
      }
   for(int i=0;i<6;i++){
     soldierX[i] = floor(random(0,8));
     soldierY[i] = floor(random(0,4));
   }

}

void draw() {

  switch (gameState) {

    case GAME_START: // Start Screen
    image(title, 0, 0);
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
      }

    }else{

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);

    }

    break;

    case GAME_RUN: // In-Game
    // Background
    image(bg, 0, 0);

    // Sun
      stroke(255,255,0);
      strokeWeight(5);
      fill(253,184,19);
      ellipse(590,50,120,120);

      // CAREFUL!
      // Because of how this translate value is calculated, the Y value of the ground level is actually 0
    pushMatrix();
    translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

    // Ground

    fill(124, 204, 25);
    noStroke();
    rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

    // Soil

    for(int i = 0; i < soilHealth.length; i++){
      for (int j = 0; j < soilHealth[i].length; j++) {

        // Change this part to show soil and stone images based on soilHealth value
        // NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
        int areaIndex = floor(j / 4);
        image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
        
      }
    }

    //stones
    
     for (int n=0; n< 8; n++){
      image(stones[0][4],0+80*n,80*n,80,80);
    }
    
    
     for(int t=1;t<=8;t++){
     for(int i=0;i<8;i++){
      if( t%4==0 || t%4== 1){
      if( i%4 == 0 || i%4== 1 ){
        image(stones[0][4],80+i*80,560+t*80,80,80);
       soilHealth[i+1][t+7] = 30 ;
      }
      }
      if(t%4==2 || t%4==3){
      if(i%4 ==2 ){
        image(stones[0][4],-160+i*80,560+t*80,80,80);
        soilHealth[i-2][t+7] = 30 ;
      }
      if(i%4 ==3){
        image(stones[0][4],i*80,560+t*80,80,80);
        soilHealth[i][t+7] = 30 ;
      }
     }
      for (int b=0;b<9;b++){
        for(int k=-1;k<15;k++){
          if(k%3 ==1 ||k%3==2){
        image(stones[0][4],0+80*k-80*b,1280+b*80,80,80);
          if(k%3 ==2){
        image(stones[1][4],0+80*k-80*b,1280+b*80,80,80);
        
        }
          }
        }
      }
     
     }
     }
     
     
      for(int i = 0 ; i < 8 ; i++){
      soilHealth[i][i]=30;
    }
    
  
   

     
     for(int n=1;n>-1;n--){
    soilHealth[n][17-n]=30;
   }
  
   for(int n=2;n>-1;n--){
    soilHealth[n][18-n]=45;
   }
   
   for(int n=4;n>-1;n--){
    soilHealth[n][20-n]=30;
   }
   for(int n=5;n>-1;n--){
    soilHealth[n][21-n]=45;
   }
   
    for(int n=7;n>-1;n--){
    soilHealth[n][23-n]=30;
   }
   for(int n=1;n<8;n++){
    soilHealth[n][24-n]=45;
   }
   
    for(int n=0;n<5;n++){
    soilHealth[3+n][23-n]=30;
   }
   for(int n=0;n<4;n++){
    soilHealth[4+n][23-n]=45;
   }
   
    for(int n=0;n<2;n++){
    soilHealth[6+n][23-n]=30;
   }
 
    soilHealth[7][23]=45;
    
    
  
     
   
   

      
      
      //soilEmpty
      for(int i = 1 ; i < 24; i++){
     
      image ( soilEmpty, 80*hole1[i] ,80*i );
      soilHealth[hole1[i]][i] = 0 ;
      image ( soilEmpty, 80*hole2[i] ,80*i );
      soilHealth[hole2[i]][i] = 0 ;
    }
    
    if(playerHealth<=5){
        for(int h =0; h<playerHealth ; h++){
          int x =10+70*h;
          image(lifeImg,x,-150+w,50,50);
        }
       for(int i = 0;i<6;i++){
         if(playerHealth<5){
        if ( playerX<80*cabbageX[i]+80&& playerX+80>80*cabbageX[i] && playerY<320*i+80*cabbageY[i]+80 && playerY+80>320*i+80*cabbageY[i]){
          playerHealth ++ ;
          cabbageX[i]=90;
        }
        if(playerHealth==5){
          cabbageX[i]=cabbageX[i];
        }
         
        }
      
    }
  
    }
   
     
    // Cabbages
    
      for(int i=0;i<6;i++){
      image(cabbage, 80*cabbageX[i] , 320*i + 80*cabbageY[i]);
    }
    
    for(int i=0;i<6;i++){
      image(soldier, 80*soldierX[i] , 320*i + 80*soldierY[i]);
    }
    
    // > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!

    // Groundhog

    PImage groundhogDisplay = groundhogIdle;

    // If player is not moving, we have to decide what player has to do next
    if(playerMoveTimer == 0){

      // HINT:
      // You can use playerCol and playerRow to get which soil player is currently on

      // Check if "player is NOT at the bottom AND the soil under the player is empty"
      // > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
      // > Else then determine player's action based on input state

      if(leftState){

        groundhogDisplay = groundhogLeft;

        // Check left boundary
        if(playerCol > 0){

          // HINT:
          // Check if "player is NOT above the ground AND there's soil on the left"
          // > If so, dig it and decrease its health
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)

          playerMoveDirection = LEFT;
          playerMoveTimer = playerMoveDuration;

        }

      }else if(rightState){

        groundhogDisplay = groundhogRight;

        // Check right boundary
        if(playerCol < SOIL_COL_COUNT - 1){

          // HINT:
          // Check if "player is NOT above the ground AND there's soil on the right"
          // > If so, dig it and decrease its health
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)

          playerMoveDirection = RIGHT;
          playerMoveTimer = playerMoveDuration;

        }

      }else if(downState){

        groundhogDisplay = groundhogDown;

        // Check bottom boundary

        // HINT:
        // We have already checked "player is NOT at the bottom AND the soil under the player is empty",
        // and since we can only get here when the above statement is false,
        // we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
        if(playerRow < SOIL_ROW_COUNT - 1){

          // > If so, dig it and decrease its health

          // For requirement #3:
          // Note that player never needs to move down as it will always fall automatically,
          // so the following 2 lines can be removed once you finish requirement #3

          playerMoveDirection = DOWN;
          playerMoveTimer = playerMoveDuration;


        }
      }

    }

    // If player is now moving?
    // (Separated if-else so player can actually move as soon as an action starts)
    // (I don't think you have to change any of these)

    if(playerMoveTimer > 0){

      playerMoveTimer --;
      switch(playerMoveDirection){

        case LEFT:
        groundhogDisplay = groundhogLeft;
        if(playerMoveTimer == 0){
          playerCol--;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
        }

   
     
        break;

        case RIGHT:
        groundhogDisplay = groundhogRight;
        if(playerMoveTimer == 0){
          playerCol++;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
        }
        break;

        case DOWN:
      
        groundhogDisplay = groundhogDown;
          
        if(playerMoveTimer == 0){
            w+=80;
          if( w>1600)w=1600;
          q++;
          playerRow++;
         
          playerY = SOIL_SIZE * playerRow;
        }else{
         
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        }
        break;
      }

    }

    image(groundhogDisplay, playerX, playerY);

    // Soldiers
    // > Remember to stop player's moving! (reset playerMoveTimer)
    // > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
    // > Remember to reset the soil under player's original position!

    // Demo mode: Show the value of soilHealth on each soil
    // (DO NOT CHANGE THE CODE HERE!)

    if(demoMode){  

      fill(255);
      textSize(26);
      textAlign(LEFT, TOP);

      for(int i = 0; i < soilHealth.length; i++){
        for(int j = 0; j < soilHealth[i].length; j++){
          text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
        }
      }

    }

    popMatrix();

    // Health UI

    break;

    case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);
    
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;

        // Initialize player
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealth = 2;

        // Initialize soilHealth
        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for(int i = 0; i < soilHealth.length; i++){
          for (int j = 0; j < soilHealth[i].length; j++) {
             // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
            soilHealth[i][j] = 15;
          }
        }

        // Initialize soidiers and their position

        // Initialize cabbages and their position
        
      }

    }else{

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

    }
    break;
    
  }
}

void keyPressed(){
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = true;
      break;
      case RIGHT:
      rightState = true;
      break;
      case DOWN:
      downState = true;
          
      break;
    }
  }else{
    if(key=='b'){
      // Press B to toggle demo mode
      demoMode = !demoMode;
    }
  }
}

void keyReleased(){
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = false;
      break;
      case RIGHT:
      rightState = false;
      break;
      case DOWN:
      downState = false;
      break;
    }
  }
}
