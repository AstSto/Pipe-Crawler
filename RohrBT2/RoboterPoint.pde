// Klasse beeinhaltet einfach nur Mittelpunkt, dessen Richtung sowie Radius und speichert diese

class RobPoint {
  PVector pos, dir;        //dir - in welche richtung der roboter fährt
  int rad;                  //Radius des Rohrs (variabel mögl)
  boolean loch;
  float lochwinkel;

  RobPoint(PVector robpos, int radius) {
    pos = robpos.copy();
    dir = new PVector(1, 0, 0);    //Initialwert
    rad = radius;
    loch = false;
    lochwinkel = 0;
  }
}