/*
*    INVERT - Fixed Polygon Obstacle Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class FixedPolygon implements Obstacle {

  int random;
  PVector[] points;
  boolean passedHalf = false;
  
  //Initialise the fixed polygon with it's initial random position.
  FixedPolygon() {
      int numberOfPoints = 4;
      points = new PVector[numberOfPoints];
      float shapeRadius = random(200, 400);
      float halfShapeRadius = shapeRadius/2;
      float yOrigin = random (height/2 - 200, height/2 + 200);
      points[0] = new PVector(width + halfShapeRadius + random(-shapeRadius/2, shapeRadius/2), yOrigin - halfShapeRadius + random(0, shapeRadius/3));
      points[1] = new PVector(width + shapeRadius + random(0, shapeRadius/2), yOrigin + random(-shapeRadius/2, shapeRadius/2));
      points[2] = new PVector(width + halfShapeRadius + random(-shapeRadius/2, shapeRadius/2), yOrigin + halfShapeRadius + random(0, shapeRadius/3));
      points[3] = new PVector(width + random(0, shapeRadius/2), yOrigin + random(-shapeRadius/2, shapeRadius/2));
  }
  
  //Moves the fixed polygon across the screen by shifting the position of each of the PVector points.
  public void moveObstacle() {
    for (int i = 0; i < points.length; i++) {
      points[i].x -= Invert.getGameSpeed();
    }
  }
  
  //Draws the fixed polygon at its current position.
  public void drawObstacle() {
    colorMode(HSB);
    noStroke();
    fill(Invert.getCurrentColour(), 255, 255);
    beginShape();
    for (PVector point : points) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
  }
  
  //Returns whether any of the points in the given array are contained within the area of the fixed polygon.
  public boolean containsPoints(PVector[] points) {
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
  
  public boolean hasPassed() {
    for (PVector point : points) {
      if (point.x > 0) {
        return false;
      }
    }
    return true;
  }
}