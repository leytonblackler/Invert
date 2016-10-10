/*
*    INVERT - Moving Bars Obstacle Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class MovingBars implements Obstacle {

  float barX;
  float verticalSpeed;
  float barHeight = 200;
  float barWidth = 50;
  float gap = 180;
  ArrayList<PVector[]> bars;

  String direction;
  
  //Initialise the moving bars with the initial random positions.
  MovingBars() {
    if (random(1) < 0.5) {
      direction = "downwards";
    } else {
      direction = "upwards";
    }

    verticalSpeed = random(1, 4);

    barX = width;
    float y;
    bars = new ArrayList<PVector[]> ();
    if (direction.equals("downwards")) {
      y = 0;
      for (int i = 0; i < 3; i++) {
        PVector[] bar = new PVector[4];
        bar[0] = new PVector(barX, y - barHeight);
        bar[1] = new PVector(barX + barWidth, y - barHeight);
        bar[2] = new PVector(barX + barWidth, y);
        bar[3] = new PVector(barX, y);
        bars.add(bar);
        y += barHeight + gap;
      }
      y = 0;
      for (int i = 0; i < 3; i++) {
        PVector[] bar = new PVector[4];
        bar[0] = new PVector(barX, y - barHeight);
        bar[1] = new PVector(barX + barWidth, y - barHeight);
        bar[2] = new PVector(barX + barWidth, y);
        bar[3] = new PVector(barX, y);
        bars.add(bar);
        y -= barHeight + gap;
      }
    } else if (direction.equals("upwards")) {
      y = height;
      for (int i = 0; i < 3; i++) {
        PVector[] bar = new PVector[4];
        bar[0] = new PVector(barX, y);
        bar[1] = new PVector(barX + barWidth, y);
        bar[2] = new PVector(barX + barWidth, y + barHeight);
        bar[3] = new PVector(barX, y + barHeight);
        bars.add(bar);
        y -= barHeight + gap;
      }
      y = height;
      for (int i = 0; i < 3; i++) {
        PVector[] bar = new PVector[4];
        bar[0] = new PVector(barX, y);
        bar[1] = new PVector(barX + barWidth, y);
        bar[2] = new PVector(barX + barWidth, y + barHeight);
        bar[3] = new PVector(barX, y + barHeight);
        bars.add(bar);
        y += barHeight + gap;
      }
    }
  }
  
  //Moves the moving bars across the screen by shifting the position of each of the PVector points.
  public void moveObstacle() {
    ArrayList<PVector[]> tempBars = new ArrayList<PVector[]> ();
    for (PVector[] bar : bars) {
      for (PVector point : bar) {
        point.x -= Invert.getGameSpeed();
        if (direction.equals("downwards")) {
          point.y += verticalSpeed;
        } else if (direction.equals("upwards")) {
          point.y -= verticalSpeed;
        }
      }
      tempBars.add(bar);
    }
    bars = tempBars;
  }
  
  //Draws the moving bars at their current position.
  public void drawObstacle() {
    colorMode(HSB);
    noStroke();
    fill(Invert.getCurrentColour(), 255, 255);
    for (PVector[] bar : bars) {
      beginShape();
      for (PVector point : bar) {
        if (point != null) {
          vertex(point.x, point.y);
        }
      }
      endShape(CLOSE);
    }
  }
  
  //Returns whether any of the points in the given array are contained within the area of the moving bars.
  public boolean containsPoints(PVector[] points) {
    for (PVector[] bar : bars) {
      for (PVector point : points) {
        int a, b;
        boolean result = false;
        int sides = 4;
        for (a = 0, b = sides - 1; a < sides; b = a++) {
          if ((((bar[a].y <= point.y) && (point.y < bar[b].y)) || ((bar[b].y <= point.y) && (point.y < bar[a].y))) &&
            (point.x < (bar[b].x - bar[a].x) * (point.y - bar[a].y) / (bar[b].y - bar[a].y) + bar[a].x)) {
            result = !result;
          }
        }
        if (result == true) {
          return result;
        }
      }
    }
    return false;
  }
  
  //Returns whether the moving bars have moved off the screen.
  public boolean hasPassed() {
    if (bars.get(0)[1].x > 0) {
      return false;
    }
    return true;
  }
}