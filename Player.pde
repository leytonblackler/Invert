/*
*    INVERT - Player Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class Player {

  float x = 200;
  float y = height/2;
  float size = 40;
  String state = "middle";
  float prevX = 0, prevY = height/2;

  int colour;

  boolean dead = false;

  boolean shieldActive = false;
  int timeShieldExpires = 0;

  PVector[] collisionPoints;
  ArrayList<PVector> tailPoints = new ArrayList<PVector> ();
  
  Player() {
    //Initialise the collision points array with PVectors.
    collisionPoints = new PVector[8];
    for (int i = 0; i < collisionPoints.length; i++) {
      collisionPoints[i] = new PVector();
    }

    //Initialise the tail points with PVectors.
    for (int i = 0; i < x; i += 2) {
      tailPoints.add(new PVector(i, height/2));
    }
  }
  
  //Draws the player at it's current position.
  void drawPlayer() {
    noStroke();
    if (shieldActive) {
      if (colour >= 255) {
        colour = 0;
      } else {
        colour += 5;
      }
      colorMode(HSB);
      fill(colour, 255, 255);
      ellipse(x, y, size, size);
      fill(colour, 255, 100);
      textAlign(CENTER, CENTER);
      textSize(26);
      text((int) ((timeShieldExpires - millis()) / 1000) + 1, x, y);
    } else {
      colorMode(RGB);
      fill(255);
      ellipse(x, y, size, size);
    }
  }
  
  //Returns whether the player is currently dead.
  boolean isDead() {
    return dead;
  }
  
  //Sets the player's state to dead.
  void die() {
    dead = true;
  }

  //Calculates the location of the 8 collision checking points.
  PVector[] getCollisionPoints() {
    int angle = 0;
    for (PVector point : collisionPoints) {
      point.x = (float)(size/2 * Math.cos(angle * Math.PI / 180)) + this.x;
      point.y = (float)(size/2 * Math.sin(angle * Math.PI / 180)) + this.y;
      angle += 45;
    }
    return collisionPoints;
  }
  
  //Changes the direction the player is moving in, either up or down.
  void changeDirection() {
    if (state.equals("down") || state.equals("middle")) {
      state = "up";
    } else if (state.equals("up")) {
      state = "down";
    }
    prevX = x;
    prevY = y;
  }
  
  //Moves the player across the screen by shifting the position of each of the PVector points.
  void movePlayer() {
    if (shieldActive && timeShieldExpires < millis()) {
      shieldActive = false;
    }

    if (state.equals("up") && y > size/2) {
      y -= Invert.getGameSpeed();
    } else if (state.equals("down") && y < height - size/2) {
      y += Invert.getGameSpeed();
    }
    for (PVector location : tailPoints) {
      location.x -= Invert.getGameSpeed();
    }
    tailPoints.remove(0);
    tailPoints.add(new PVector(x, y));
  }
  
  //Draws the tail behind the player based on previous locations.
  void drawTail() {
    if (!tailPoints.isEmpty()) {

      strokeWeight(15);
      int greyLevel = 200;
      for (int i = tailPoints.size() - 1; i > 1; i--) {
        if (greyLevel > 255) {
          greyLevel = 255;
        }
        stroke(greyLevel);
        line(tailPoints.get(i).x, tailPoints.get(i).y, tailPoints.get(i-1).x, tailPoints.get(i-1).y);
        greyLevel += 4;
      }
    }
  }
  
  //Activate the player's shield for 10 seconds.
  void activateShield() {
    timeShieldExpires = millis() + 10000;
    colour = 0;
    shieldActive = true;
  }
  
  //Deactivate the player's shield.
  void deactivateShield() {
    shieldActive = false;
  }
  
  //Returns whether the player has an active shield.
  boolean hasActiveShield() {
    return shieldActive;
  }
  
  //Returns the current centre position of the player.
  PVector getPosition() {
    return new PVector(x, y);
  }
}