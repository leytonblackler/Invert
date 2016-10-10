/*
*    INVERT - Coin Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class Coin {
  
  PVector[] points;
  float size = 20;
  boolean deleted = false;
  
  //Initialise the coin with it's intial position.
  Coin () {
    points = new PVector[4];
    float randomY = random(80, height - 50);
    points[0] = new PVector(width + size/2, randomY - size/2);
    points[1] = new PVector(width + size, randomY);
    points[2] = new PVector(width + size/2, randomY + size/2);
    points[3] = new PVector(width, randomY);
  }
  
  //Draws the coin at it's current position.
  void drawCoin() {
    if (!deleted) {
      colorMode(RGB);
      fill(255, 140);
      noStroke();
      beginShape();
      for (PVector point : points) {
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    }
  }
  
  //Moves the coin across the screen by shifting the position of each of the PVector points.
  void moveCoin() {
    for (PVector point : points) {
      point.x -= Invert.getGameSpeed();
    }
  }
  
  //Returns the current position of the coin.
  PVector[] getLocation() {
    return points;
  }
  
  //Return the point at the centre of the coin.
  PVector getCentrePoint() {
    return new PVector(points[0].x + size/2, points[0].y + size/2);
  }
  
  //Set the state of the coin as deleted.
  void delete() {
    deleted = true;
  }
  
  //Returns whether the coin has been deleted.
  boolean isDeleted() {
    return deleted;
  }
  //Returns whether any of the points in the given array are contained within the area of the coin.
  boolean containsPoints(PVector[] points) {
    for (PVector point : points) {
      int a, b;
      boolean result = false;
      int sides = this.points.length;
      
      for (a = 0, b = sides - 1; a < sides; b = a++) {
        if ((((this.points[a].y <= point.y) && (point.y < this.points[b].y)) || ((this.points[b].y <= point.y) && (point.y < this.points[a].y))) &&
          (point.x < (this.points[b].x - this.points[a].x) * (point.y - this.points[a].y) / (this.points[b].y - this.points[a].y) + this.points[a].x)) {
          result = !result;
        }
      }
      if (result == true) {
        return result;
      }
    }
    return false;
  }
}