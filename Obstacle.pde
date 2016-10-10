/*
*    INVERT - Obstacle Interface
*    CGRA151 Assignment 5
*    Author: Leyton Blackler
*    ID: 300368625
*/

interface Obstacle {
  
  void moveObstacle();
  
  void drawObstacle();
  
  boolean hasPassed();
  
  boolean containsPoints(PVector[] points);
}