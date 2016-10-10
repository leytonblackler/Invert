/*
*    INVERT - Explosion Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class Explosion {

  PVector origin;
  float distance = 20;
  float speed = 10;
  float size = 6;
  float acceleration = 2;
  float angleDifference = 0;
  float opacity = 255;
  int timeExploded;
  float opacityDifference;

  String type;

  PVector[] particlePositions = new PVector[32];
  
  //Initialise the array depending on the type of explosion given and initial position given.
  Explosion(String type, PVector origin) {
    this.type = type;
    if (type.equals("particle")) {
      opacityDifference = 10;
    } else if (type.equals("circle")) {
      opacityDifference = 40;
    } else {
      opacityDifference = 255;
    }
    this.origin = origin;

    timeExploded = millis();
    float angle = 0;
    for (int i = 0; i < particlePositions.length; i++) {
      particlePositions[i] = new PVector((float)(distance * Math.cos((angle+angleDifference) * Math.PI / 180)) + origin.x, (float)(distance * Math.sin((angle+angleDifference) * Math.PI / 180)) + origin.y);
      angle += 11.25;
    }
  }
  
  //Draw the explosion effect.
  void drawExplosion() {
    if (!player.isDead() || Invert.gamePaused()) {
      origin.x -= Invert.getGameSpeed();
    }

    colorMode(RGB);

    if (type.equals("particle")) {
      fill(255, 255, 255, opacity);
      noStroke();
      float angle = 0;
      for (int i = 0; i < particlePositions.length; i++) {

        particlePositions[i].x = (float)(distance * Math.cos((angle+angleDifference) * Math.PI / 180)) + origin.x;
        particlePositions[i].y = (float)(distance * Math.sin((angle+angleDifference) * Math.PI / 180)) + origin.y;
        ellipse(particlePositions[i].x, particlePositions[i].y, size, size);
        angle += 11.25;
      }
      angleDifference += 1;
    } else if (type.equals("circle")) {
      noFill();
      stroke(255, opacity);
      strokeWeight(3);
      ellipse(origin.x, origin.y, distance, distance);
    }


    distance += speed;
    opacity -= opacityDifference;
  }
  
  //Return whether the explosion effect has finished and is no longer visible.
  boolean hasFaded() {
    if (timeExploded + 2000 > millis()) {
      return false;
    }
    return true;
  }
}