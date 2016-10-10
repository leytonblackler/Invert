/*
*    INVERT - Main Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

//The Minim library is used for game audio.
import ddf.minim.*;

//Initialise the sound library.
Minim minim = new Minim(this);

//Constant value used to determine the overall speed of the game.
public static float GAME_SPEED = 7;

/*  Sound effects are from the 'Dustryroom Causual Game Sounds - One Shot SFX Pack'.
 *  Used with permission under the CC Zero license.
 *  http://dustyroom.com/casual-game-sfx-freebie/
 */
AudioPlayer moveSound;
AudioPlayer buttonSound;
AudioPlayer coinSound;
AudioPlayer shieldSound;
AudioPlayer obstacleSound;
AudioPlayer gameOverSound;

/*  Background music: UWBeats - Wonderland
 *  Used with permission under the CC BY 3.0 license.
 */
AudioPlayer music;

//Used to retain current music and sound state.
boolean soundsLoaded = false;
boolean musicStopped = true;
boolean muted = false;

//Define the class objects.
Player player;
Border border;
Shield shield;

//Used to retain current game paused state.
public static boolean paused;

//Using to retain whether the start screen is active.
boolean startScreen = true;

//Define the array list where obstacle objects are stored.
ArrayList<Obstacle> obstacles;
//Define the field where the time until the next obstacle should be generated is stored.
int timeForNewObstacle;

//Define the array list where coin objects are stored.
ArrayList<Coin> coins;
//Define the field where the time until the next coin should be generated is stored.
int timeForNewCoin;

//Define the field where the time until the next shield should be generated is stored.
int timeForNewShield;

//Define the array list where explosion/collision animation objects are stored.
ArrayList<Explosion> explosions;

//Used to record how far the player has travelled in a single game.
int distance;

//Used to record how many coins a player has collected in a single game.
int coinsCollected;

//Used to store the player's final score after completing a game.
int finalScore;

//Used to retain the highest score achieved in a given instance of the game.
int highScore = 0;

//Used to retain the current hue value for the game's main colour.
public static float mainColour = 0;

//Define image variable for the game logo.
PImage logo;

//Define the font variable for the game UI.
PFont KelsonBold;

void setup() {

  //Set the game window size to 720p.
  size(1280, 720);

  //Import the game logo image.
  logo = loadImage("logo.png");

  //Set the text on window's title bar. 
  surface.setTitle("INVΞRT");

  //If the sounds haven't yet been imported, import the sounds.
  if (!soundsLoaded) {
    music = minim.loadFile("music.mp3");
    music.setGain(-10);
    moveSound = minim.loadFile("move.mp3");
    moveSound.setGain(-15);
    buttonSound = minim.loadFile("button.mp3");
    coinSound = minim.loadFile("coin.mp3");
    shieldSound = minim.loadFile("shield.mp3");
    obstacleSound = minim.loadFile("obstacle.mp3");
    gameOverSound = minim.loadFile("game_over.mp3");
    soundsLoaded = true;
  }

  //Initialise the game UI font.
  KelsonBold = createFont("Kelson-Bold.otf", 32);
  //Set the font.
  textFont(KelsonBold);

  //Set the paused flag to false.
  paused = false;

  //Initialise the player object.
  player = new Player();

  //Initialise the border object.
  border  = new Border();

  //Initialise the shield as null so it does not yet exist.
  shield = null;

  //Define the array list where explosion/collision animation objects are stored.
  explosions = new ArrayList<Explosion> ();

  //Define the array list where obstacle objects are stored.
  obstacles = new ArrayList<Obstacle> ();

  //Define the array list where coin objects are stored.
  coins = new ArrayList<Coin> ();

  //Set the time until a new obstacle is generated to 1 second.
  timeForNewObstacle = 1000;

  //Set the time until a new coin is generated to between 2 and 2.5 seconds.
  timeForNewCoin = int(random(millis() + 2000, millis() + 2500));

  //Set the time until a new shield is generated to between 5 and 10 seconds.
  timeForNewShield = int(random(millis() + 5000, millis() + 10000));

  //Set the current distance as 0 to initialise a new game.
  distance = 0;

  //Set the current coin count as 0 to initialise a new game.
  coinsCollected = 0;

  //Set the final score as 0 to initialise a new game.
  finalScore = 0;
}

void draw() {

  //If music should be muted but is still playing, pause the music.
  if (muted && !musicStopped) {
    music.pause();
    musicStopped = true;
  }

  //If the music should be unmuted but is not playing, player the music.
  if (!muted && musicStopped) {
    music.loop();
    musicStopped = false;
  }

  //If the start screen should be displayed, display the start screen and ignore rest of draw method.
  if (startScreen) {
    displayStartScreen();
    return;
  }

  //If the player is dead, replace the current highscore with their score, if their final score is higher.
  if (player.isDead()) {
    if (finalScore > highScore) {
      highScore = finalScore;
    }
  }

  //Set the colour mode to Hue-Saturation-Brightness;
  colorMode(HSB);

  //Set the background to the colour with the current hue value.
  background(mainColour, 255, 100);

  //If the player is alive and the game is running, increase the distance travelled value.
  if (!paused && !player.isDead()) {
    distance++;
  }

  //Cycle to the next hue value.
  cycleColour();

  //If the game is running, the player is alive and the time until a new coin should be generated is up, generate a new coin.
  if (timeForNewCoin < millis() && !player.isDead() && !paused) {
    coins.add(new Coin());
    timeForNewCoin = int(random(millis() + 500, millis() + 1500));
  }

  //Move and draw the coins.
  //If the player has collided with a coin, remove it from the array list, play a sound and create a new explosion effect.
  ArrayList tempCoins = new ArrayList<Coin> ();
  if (!coins.isEmpty()) {
    for (Coin coin : coins) {
      if (!paused && !player.isDead()) {
        coin.moveCoin();
      }
      coin.drawCoin();
      if (!coin.isDeleted()) {
        tempCoins.add(coin);
      }
      if (coin.containsPoints(player.getCollisionPoints()) && !coin.isDeleted() && !player.isDead()) {
        coinSound.rewind();
        coinSound.play();
        coinsCollected++;
        coin.delete();
        explosions.add(new Explosion("circle", new PVector(coin.getCentrePoint().x, coin.getCentrePoint().y)));
      }
    }
  }
  coins = tempCoins;

  //If a shield exists, move and draw it.
  //If the player has collided with the shield, delete it, activate the player's shield, play a sound and create a new explosion effect.
  if (shield != null) {
    if (!player.isDead() && !paused) {
      shield.moveShield();
    }
    shield.drawShield();

    if (shield.containsPoints(player.getCollisionPoints())) {
      shieldSound.rewind();
      shieldSound.play();
      player.activateShield();
      explosions.add(new Explosion("circle", new PVector(shield.getCentrePoint().x, shield.getCentrePoint().y)));
      shield = null;
      timeForNewShield = int(random(millis() + 5000, millis() + 10000));
    }

    //If the time until a new shield should be generated is up, generate a new shield.
  } else {
    if (timeForNewShield < millis()) {
      shield = new Shield();
    }
  }

  //If the player is alive and the game is running, move and draw the player.
  if (!player.isDead()) {
    if (!paused) {
      player.movePlayer();
    }
    player.drawTail();
    player.drawPlayer();
  }

  //Move and draw the obstacles.
  //If an obstacle has moved off screen, remove it from the arraylist.
  ArrayList tempObstacles = new ArrayList<Obstacle> ();
  if (!obstacles.isEmpty()) {
    for (Obstacle obstacle : obstacles) {
      if (!obstacle.hasPassed()) {
        tempObstacles.add(obstacle);
        obstacle.drawObstacle();
        if (!player.isDead() && !paused) {
          obstacle.moveObstacle();
        }
      }
    }
  }

  //If the time until a new obstacle should be generated is up, generate a new obstacle.
  if (timeForNewObstacle < millis()) {

    //Generate a random value from 0 to 1.
    float random = random(1);

    //50% chance of the obstacle being a fixed polygon.
    if (random >= 0 && random < 0.5) {
      tempObstacles.add(new FixedPolygon());

      //25% chance of the obstacle being moving bars.
    } else if (random >= 0.5 && random < 0.75) {
      tempObstacles.add(new MovingBars());

      //25% chance of the obstacle being a rotating bar.
    } else if (random >= 0.75 && random < 1) {
      tempObstacles.add(new RotatingBar());
    }

    //Set the time until a new obstacle is generated to between 1.5 and 2 seconds.
    timeForNewObstacle = int(random(millis() + 1500, millis() + 2000));
  }

  //Set the colour mode to Red-Green-Blue.
  colorMode(RGB);

  //Set the fill to white.
  fill(255);

  //If the player has collided with an obstacle and has an active shield, deactivate the shield, play a sound, create a new explosion effect and remove the obstacle from the array list.
  //If the player has collided with the border and has an active shield, deactivate the shield, play a sound, create a new explosion effect and change the player's direction.
  //If the player has collided with an obstacle or the border and does not have an active shield, play a sound, create a new explosion effect and end the game.
  for (Obstacle obstacle : obstacles) {
    if ((obstacle.containsPoints(player.getCollisionPoints()) || border.containsPoints(player.getCollisionPoints())) && !player.isDead()) {
      if (player.hasActiveShield()) {
        obstacleSound.rewind();
        obstacleSound.play();
        player.deactivateShield();
        if (obstacle.containsPoints(player.getCollisionPoints()) && tempObstacles.contains(obstacle)) {
          tempObstacles.remove(obstacle);
        } else if (border.containsPoints(player.getCollisionPoints())) {
          player.changeDirection();
        }
      } else {
        gameOverSound.rewind();
        gameOverSound.play();
        player.die();
      }
      explosions.add (new Explosion("particle", player.getPosition()));
      break;
    }
  }
  obstacles = tempObstacles;

  //Draw all of the current explosion effects.
  //Remove any explosion that has faded away from the array list.
  ArrayList tempExplosions = new ArrayList<Explosion> ();
  if (!explosions.isEmpty()) {
    for (Explosion explosion : explosions) {
      if (!explosion.hasFaded()) {
        explosion.drawExplosion();
        tempExplosions.add(explosion);
      }
    }
  }
  explosions = tempExplosions;

  //If the player is alive and the game is running, move and draw the border.
  if (!player.isDead() && !paused) {
    border.moveBorder();
  }
  border.drawBorder();

  //Set the colour mode to Hue-Saturation-Brightness;
  colorMode(HSB);

  //Set the fill to the colour with the current hue value.
  fill(mainColour, 255, 170);

  //Draw the text on the top UI bar.
  textAlign(LEFT, CENTER);
  textSize(18);
  text("DISTANCE: " + distance, 200, 18);
  text("COINS: " + coinsCollected, 430, 18);
  text("HIGH SCORE: " + highScore, 630, 18);

  //Draw the menu buttons.
  drawButtons();

  //If the game is paused, draw the pause menu.
  if (paused) {
    colorMode(RGB);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(120);
    text("PAUSED", width/2, height/2);

    colorMode(HSB);
    fill(mainColour, 255, 160);
    textSize(15);
    text("[PRESS THE PAUSE BUTTON OR 'P' TO RESUME.]", width/2, height/2 + 70);
  }

  //If the player is dead, draw the game over menu.
  if (player.isDead()) {
    colorMode(RGB);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(120);
    text("GAME OVER", width/2, height/2);
    textSize(15);
    text("DISTANCE: " + distance + "             COINS: " + coinsCollected + " (x100)", width/2, height/2 + 65);
    textSize(30);
    finalScore = distance + (100 * coinsCollected);
    text("FINAL SCORE: " + finalScore, width/2, height/2 + 95);

    colorMode(HSB);
    fill(mainColour, 255, 160);
    textSize(15);
    text("[PRESS THE RESTART BUTTON OR 'R' TO RESTART.]", width/2, height/2 + 130);
  }
}

//Returns the current hue value for the main colour.
public static int getCurrentColour() {
  return (int) mainColour;
}



//Increases the hue value for the main colour. Resets to 0 if max value reached.
void cycleColour() {
  if (mainColour >= 255) {
    mainColour = 0;
  } else {
    mainColour += 0.3;
  }
}

//Draws the start menu screen.
void displayStartScreen() {
  colorMode(HSB);
  if (mainColour < 256) {
    background(mainColour, 255, 200);

    textAlign(RIGHT, BOTTOM);
    fill(mainColour, 255, 160);
    textSize(18);
    text("MADE BY LEYTON BLACKLER", width - 5, height);

    textAlign(CENTER, CENTER);
    fill(255);
    textSize(120);
    logo.resize(450, 0);
    image(logo, width/2 - 225, height/2 - 140);

    if (mouseOver("Start")) {
      stroke(255);
      fill(255);
      strokeWeight(5);
    } else {
      stroke(255);
      noFill();
      strokeWeight(5);
    }
    if (mousePressed && mouseOver("Start")) {
      rect(width/2 - 95, height/2 + 55, 190, 40);
    } else {
      rect(width/2 - 100, height/2 + 50, 200, 50);
    }

    textSize(20);
    if (mouseOver("Start")) {
      fill(mainColour, 255, 200);
    } else {
      fill(255);
    }
    text("START", width/2, height/2 + 75);

    //Cycle to the next hue value.
    cycleColour();
  }
}

//returns whether the game is currently paused.
public static boolean gamePaused() {
  return paused;
}

//Returns the constant game speed value.
public static float getGameSpeed() {
  return GAME_SPEED;
}

//Returns whether the mouse position is over a given button.
boolean mouseOver(String button) {
  if (button.equals("Start")) {
    return mouseX > width/2 - 105 && mouseX < width/2 + 105 && mouseY > height/2 + 45 && mouseY < height/2 + 105;
  }
  if (button.equals("Pause")) {
    return mouseX > 9 && mouseX < 31 && mouseY > 7 && mouseY < 29;
  }
  if (button.equals("Restart")) {
    return mouseX > 49 && mouseX < 71 && mouseY > 7 && mouseY < 29;
  }
  if (button.equals("Mute")) {
    return mouseX > 89 && mouseX < 111 && mouseY > 7 && mouseY < 29;
  }
  return false;
}

void mousePressed() {
  if (!startScreen) {
    if (!paused && !player.isDead() && !mouseOver("Pause") && !mouseOver("Restart") && !mouseOver("Mute")) {
      moveSound.rewind();
      moveSound.play();
      player.changeDirection();
    }
  }
}

//Controls various events when the mouse is released, button pressed
void mouseReleased() {
  if (startScreen) {
    if (mouseOver("Start")) {
      buttonSound.rewind();
      buttonSound.play();
      startScreen = false;
    }
  } else {
    if (mouseOver("Pause")) {
      if (!player.isDead()) {
        buttonSound.rewind();
        buttonSound.play();
      }
      if (!player.isDead()) {
        paused = !paused;
      }
    } else if (mouseOver("Restart")) {
      buttonSound.rewind();
      buttonSound.play();
      setup();
    } else if (mouseOver("Mute")) {
      buttonSound.rewind();
      buttonSound.play();
      muted = !muted;
    }
  }
}

//Controls events when certain keys are pressed, such as shortcuts for pausing, restarting, muting, etc.
void keyPressed() {
  if (!startScreen) {
    if (key == ' ') {
      moveSound.rewind();
      moveSound.play();
      player.changeDirection();
    } else if (key == 'r' || key == 'R') {
      setup();
    } else if (key == 'p' || key == 'P') {
      if (!player.isDead()) {
        buttonSound.rewind();
        buttonSound.play();
        paused = !paused;
      }
    } else if (key == 'm' || key == 'M') {
      muted = !muted;
    }
  }
}

//Draw the buttons on the top menu bar.
void drawButtons() {
  //Set the colour mode to Hue-Saturation-Brightness.
  colorMode(HSB);
  
  //Draw the pause button.
  noStroke();
  if (mouseOver("Pause")) {
    fill(mainColour, 255, 100);
  } else {
    fill(mainColour, 255, 170);
  }
  ellipse(20, 18, 22, 22);
  fill(mainColour, 255, 255);
  if (paused) {
    beginShape();
    vertex(17, 12);
    vertex(26, 18);
    vertex(17, 24);
    endShape(CLOSE);
  } else {
    rect(16, 12, 3, 12);
    rect(21, 12, 3, 12);
  }
  
  //Draw the restart button.
  noStroke();
  if (mouseOver("Restart")) {
    fill(mainColour, 255, 100);
  } else {
    fill(mainColour, 255, 170);
  }
  ellipse(60, 18, 22, 22);
  fill(mainColour, 255, 255);
  ellipse(60, 18, 15, 15);
  if (mouseOver("Restart")) {
    fill(mainColour, 255, 100);
  } else {
    fill(mainColour, 255, 170);
  }
  ellipse(60, 18, 10, 10);
  rect(60 - 3, 10, 6, 10);
  fill(mainColour, 255, 255);
  beginShape();
  vertex(64, 9);
  vertex(61, 18);
  vertex(59, 12);
  endShape(CLOSE);

  //Draw the mute button.
  noStroke();
  if (mouseOver("Mute")) {
    fill(mainColour, 255, 100);
  } else {
    fill(mainColour, 255, 170);
  }
  ellipse(100, 18, 22, 22);
  fill(mainColour, 255, 255);
  ellipse(100 - 5, 20, 5, 5);
  ellipse(100 + 3, 22, 5, 5);
  rect(100 - 4, 13, 2, 8);
  rect(100 + 4, 13, 2, 10);
  rect(100 - 4, 13, 8, 2);
  if (muted) {
    colorMode(RGB);
    stroke(255, 0, 0);
    strokeWeight(2);
    line(100 - 6, 18 - 6, 100 + 6, 18 + 6);
  }
}