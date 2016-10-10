/*
*    INVERT - Rotating Bar Obstacle Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class RotatingBar implements Obstacle {

  float outerRadius = 400;
  float innerRadius = 250;
  float rotationSpeed;
  float shapeWidth;
  PVector centre;
  float angle;
  float arrowHeight = 20;
  PVector[] points;
  
  //Initialise the rotating bar with random paramaters.
  RotatingBar() {
    
    rotationSpeed = random(1, 3);
    
    //50% chance of rotating either clockwise or anti-clockwise
    if (random(1) < 0.5) {
      rotationSpeed = -rotationSpeed;
    }

    shapeWidth = random(15, 50);
    outerRadius = random(300, 400);
    innerRadius = 0.8 * outerRadius;

    centre = new PVector(width + outerRadius, random(100 + outerRadius/2, height - 50 - outerRadius/2));
    points = new PVector[6];
    for (int i = 0; i < points.length; i++) {
      points[i] = new PVector();
    }
    angle = random(0, 360);

    calculatePoints();
  }
  
  //Moves the rotating bar across the screen by shifting the position of each of the PVector points.
  public void moveObstacle() {
    calculatePoints();
    angle -= rotationSpeed;
    centre.x -= Invert.getGameSpeed();
  }
  
  //Draws the rotating bar at it's current position.
  public void drawObstacle() {
    colorMode(HSB);
    noStroke();
    fill(Invert.getCurrentColour(), 255, 255);

    beginShape();
    //for (int i = 0; i < 3; i ++) {
    for (PVector point : points) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
    colorMode(RGB);
    noFill();
    stroke(255);
    strokeWeight(2);
  }
  
  //Returns whether the rotating bar has moved off the screen.
  public boolean hasPassed() {
    for (PVector point : points) {
      if (point.x > 0) {
        return false;
      }
    }
    return true;
  }
  
  //Returns whether any of the points in the given array are contained within the area of the rotating bar.
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
  
  //Calculates the position of each of the PVector points.
  void calculatePoints() {
    points[0].x = (float)(outerRadius/2 * Math.cos(angle * Math.PI / 180)) + centre.x;
    points[0].y = (float)(outerRadius/2 * Math.sin(angle * Math.PI / 180)) + centre.y;

    points[1].x = (float)(innerRadius/2 * Math.cos((angle + shapeWidth/2) * Math.PI / 180)) + centre.x;
    points[1].y = (float)(innerRadius/2 * Math.sin((angle + shapeWidth/2) * Math.PI / 180)) + centre.y;

    points[2].x = (float)(innerRadius/2 * Math.cos(((angle + 180) - shapeWidth/2) * Math.PI / 180)) + centre.x;
    points[2].y = (float)(innerRadius/2 * Math.sin(((angle + 180) - shapeWidth/2) * Math.PI / 180)) + centre.y;

    points[3].x = (float)(outerRadius/2 * Math.cos((angle + 180) * Math.PI / 180)) + centre.x;
    points[3].y = (float)(outerRadius/2 * Math.sin((angle + 180) * Math.PI / 180)) + centre.y;

    points[4].x = (float)(innerRadius/2 * Math.cos(((angle + 180) + shapeWidth/2) * Math.PI / 180)) + centre.x;
    points[4].y = (float)(innerRadius/2 * Math.sin(((angle + 180) + shapeWidth/2) * Math.PI / 180)) + centre.y;

    points[5].x = (float)(innerRadius/2 * Math.cos((angle - shapeWidth/2) * Math.PI / 180)) + centre.x;
    points[5].y = (float)(innerRadius/2 * Math.sin((angle - shapeWidth/2) * Math.PI / 180)) + centre.y;
  }
}