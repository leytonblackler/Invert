/*
*    INVERT - Shield Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class Shield {

  int colour = 0;

  PVector[] points;
  
  //Initialise the shield with it's initial position.
  Shield() {
    colour = 0;
    points = new PVector[9];
    float y = random(100, height - 100);
    points[0] = new PVector(width + 12, y);
    points[1] = new PVector(width + 28, y);
    points[2] = new PVector(width + 40, y + 5);
    points[3] = new PVector(width + 40, y + 20);
    points[4] = new PVector(width + 30, y + 40);
    points[5] = new PVector(width + 20, y + 50);
    points[6] = new PVector(width + 10, y + 40);
    points[7] = new PVector(width, y + 20);
    points[8] = new PVector(width, y + 5);
  }
  
  //Moves the shield across the screen by shifting the position of each of the PVector points.
  void moveShield() {
    for (PVector point : points) {
      point.x -= Invert.getGameSpeed();
    }
  }
  
  //Draws the shield at it's current position.
  void drawShield() {
    if (colour >= 255) {
      colour = 0;
    } else {
      colour += 5;
    }
    colorMode(HSB);
    fill(colour, 255, 255, 100);
    stroke(colour, 255, 255);
    strokeWeight(4);
    beginShape();
    for (PVector point : points) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
  }
  
  //Returns the point at the centre of the shield.
  PVector getCentrePoint() {
    return new PVector(points[5].x, points[3].y);
  }
  
  //Returns whether any of the points in the given array are contained within the area of the shield.
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