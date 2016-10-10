/*
*    INVERT - Border Class
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

class Border {
  
  //Define and initialise the array of PVectors for both the top and bottom segments of the border.
  PVector[] topSegments = new PVector[18];
  PVector[] bottomSegments = new PVector[18];
  
  //Initialise the PVectors in the arrays with their intial positions.
  Border() {
    int index = 0;
    for (int segment = 0; segment < 6; segment++) {

      topSegments[index] = new PVector(segment * width/5, 40);
      topSegments[index+1] = new PVector((segment * width/5) + width/5 - 100, 70);
      topSegments[index+2] = new PVector((segment * width/5) + width/5, 40);

      bottomSegments[index] = new PVector(segment * width/5, height - 10);
      bottomSegments[index+1] = new PVector((segment * width/5) + width/5 - 100, height - 40);
      bottomSegments[index+2] = new PVector((segment * width/5) + width/5, height - 10);

      index += 3;
    }
  }
  
  //Draws the border, from the points within both the top and bottom segment arrays.
  void drawBorder() {
    colorMode(HSB);
    noStroke();
    fill(Invert.getCurrentColour(), 255, 255);
    rect(0, 0, width, 40);
    rect(0, height - 10, width, 10);
    beginShape();
    for (PVector point : topSegments) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);

    beginShape();
    for (PVector point : bottomSegments) {
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
  }
  
  //Move the border across the screen by shifting each of the PVector positions in the arrays.
  void moveBorder() {
    int index = 0;
    
    //Set the initial index to 0.
    index = 0;
    
    //Loop 6 times, for each segment of the top border.
    for (int segment = 0; segment < 6; segment++) {
      //Decrease all points of the segment by 5 pixels so it moves left.
      topSegments[index].x -= Invert.getGameSpeed();
      topSegments[index+1].x -= Invert.getGameSpeed();
      topSegments[index+2].x -= Invert.getGameSpeed();
      
      //If the segment if fully off the screen to the left, reset it so it moves in from the right.
      if (topSegments[index+2].x < 0) {
        topSegments[index] = new PVector(width, 40);
        topSegments[index+1] = new PVector(width + width/5 - 100, 70);
        topSegments[index+2] = new PVector(width + width/5, 40);
      }
      
      //Increase the index by 3 so the next segment is modified in the next loop.
      index += 3;
    }
    
    //Set the initial index to 0.
    index = 0;
    
    //Loop 6 times, for each segment of the bottom border.
    for (int segment = 0; segment < 6; segment++) {
      //Decrease all points of the segment by 5 pixels so it moves left.
      bottomSegments[index].x -= Invert.getGameSpeed();
      bottomSegments[index+1].x -= Invert.getGameSpeed();
      bottomSegments[index+2].x -= Invert.getGameSpeed();
      
      //If the segment if fully off the screen to the left, reset it so it moves in from the right.
      if (bottomSegments[index+2].x < 0) {
        bottomSegments[index] = new PVector(width, height - 10);
        bottomSegments[index+1] = new PVector(width + width/5 - 100, height - 40);
        bottomSegments[index+2] = new PVector(width + width/5, height - 10);
      }
      
      //Increase the index by 3 so the next segment is modified in the next loop.
      index += 3;
    }
    
  }
  
  //Returns whether any of the points in the given array of PVectors are within the border.
  public boolean containsPoints(PVector[] points) {
    for (PVector point : points) {
      int a, b;
      boolean result = false;
      int sides;
      
      //Check top segments.
      sides = topSegments.length;
      for (a = 0, b = sides - 1; a < sides; b = a++) {
        if ((((topSegments[a].y <= point.y) && (point.y < topSegments[b].y)) || ((topSegments[b].y <= point.y) && (point.y < topSegments[a].y))) &&
          (point.x < (topSegments[b].x - topSegments[a].x) * (point.y - topSegments[a].y) / (topSegments[b].y - topSegments[a].y) + topSegments[a].x)) {
          result = !result;
        }
      }
      if (result == true) {
        return result;
      }
      
      //Check bottom segments.
      sides = bottomSegments.length;
      for (a = 0, b = sides - 1; a < sides; b = a++) {
        if ((((bottomSegments[a].y <= point.y) && (point.y < bottomSegments[b].y)) || ((bottomSegments[b].y <= point.y) && (point.y < bottomSegments[a].y))) &&
          (point.x < (bottomSegments[b].x - bottomSegments[a].x) * (point.y - bottomSegments[a].y) / (bottomSegments[b].y - bottomSegments[a].y) + bottomSegments[a].x)) {
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