
// Dieser Abschnitt kümmert sich ausschließlich um die Kamera Bewegung
// Bewegung mit WASD sowie SHIFT für Höhe gewinnen und SPACE um zu sinken
// Um die Camera zu verwenden im setup() initCamera() aufrufen
// Um die Camera zu aktualiesieren in draw() updateCamera() aufrufen

import java.awt.Robot;                  // Bibliothek um Mausposition zurückzusetzen

float eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ;
float speedeyefront, speedeyeside, speedeyeUP, normalspeed;
PVector richtung;
PVector auge, initauge, UPVec;
PVector center, initcenter;
float rmx, rmy;                  //mausposition
int started=0;
Robot robot;                      //robot Objekt vom Typ Robot(Klasse, die in der Bibliothek definiert ist) 

void initCamera() {              // initialiesiert die Kamera 
  normalspeed=30;                            // init Wert für die Augengeschwindigkeit
  initauge = new PVector(2700, 2700, 1000);        // init Werte für die Augenposition
  initcenter = new PVector(0, 0, 0);                // init Wert für Die Szene der Kamera
  UPVec = new PVector(0, 0, -1);             // init für die Richtung die als oben erscheinen soll
  auge = initauge.copy();
  noCursor();                                // deaktiviert den Curser
  try {                   
    robot = new Robot();                     // versucht Robot zu erstellen, wird benötigt um Maus in der Bildschirmmitte gefangen zu halten
  }  
  catch(Throwable e) {
  }
  zentrieren();
}


void keyPressed() {        // reagiert auf Tastendrücke und verändert die Augenposition
  if (key == 'z'||key == 'Z') {
    zentrieren();
  }
  if (key == 't'||key == 'T') {
    schrift = !schrift;
  }
  if (key == 'a'||key == 'A') {  
    speedeyeside = normalspeed;
  }
  if (key == 'w'||key == 'W') {  
    speedeyefront = normalspeed;
  }
  if (key == 's'||key == 'S') {  
    speedeyefront = -normalspeed;
  }
  if (key == 'd'||key == 'D') {
    speedeyeside = -normalspeed;
  }

  if (key == ' ') {
    speedeyeUP = -normalspeed;
    //println("Space");
  }

  if (keyCode == SHIFT) {
    speedeyeUP = +normalspeed;
  }
}
void keyReleased() {                                        // kümmert sich darum, dass Bewegung aufhört wenn eine Taste losgelassen wird
  if (key == 'w'||key == 'W'&& speedeyefront>0) {
    speedeyefront = 0;
  }
  if (key == 's'||key == 'S'&& speedeyefront<0) {
    speedeyefront = 0;
  }
  if (key == 'a'||key == 'A'&& speedeyeside>0) {
    speedeyeside = 0;
  }
  if (key == 'd'||key == 'D'&& speedeyeside<0) {
    speedeyeside = 0;
  }
  if (key == ' '&& speedeyeUP<0) {
    speedeyeUP = 0;
  }
  if (keyCode == SHIFT&& speedeyeUP>0) {
    speedeyeUP = 0;
  }
}

void updateCamera() {        // eigentliche Berechnung der Kamera

  if (started<2) {      // Zentriert das Objekt beim Start des Programmes
    zentrieren();
    started ++;
  }
  PVector front, side, speedup;
  float phi = map(rmx, 0, width, -PI, PI);              // mapt die Mausposition X auf einen Winkel phi in Kugelkoordinaten
  float deta = map(rmy, 0, height, 0, PI );              // mapt die Mausposition Y auf den Winkel deta
  richtung = new PVector(cos(phi)*sin(deta), sin(phi)*sin(deta), cos(deta));   // macht einen Richtungsvektor draus -> Umrechnung von Kugelkoordinaten in Kartesische

  richtung.normalize();                                //macht Einheitsvektor draus (Betrag 1)
  center= auge.copy();                                  //vektor auge kopiert in vektor auge 
  center.add(richtung);                                   // Punkt auf den die Camera schaut    addiert mathematisch -> Lage Betrachtungspunkt
  camera(auge.x, auge.y, auge.z, // eyeX, eyeY, eyeZ
    center.x, center.y, center.z, // centerX, centerY, centerZ
    UPVec.x, UPVec.y, UPVec.z); // upX, upY, upZ*/

  //Bewgung des Auges:
  front = richtung.copy();
  front.mult(speedeyefront);         
  auge.add(front);                  // Auge + Geschwindigkeit in Blickrichtung
  side = UPVec.cross(richtung);      // Bestimmung eines Vektors der zur Seite zeigt    Kreuzprodukt: Ergebnis - Vektor, der Senkrecht auf den 2 vektoren steht
  side.normalize();
  side.mult(speedeyeside);
  auge.add(side);                    // auge + senkrechte Geschwindigkeit
  speedup = UPVec.copy();
  speedup.mult(speedeyeUP);
  auge.add(speedup);                // auge + nach oben Gerichtete Geschwindigkeit
}

void mouseMoved() {              // speichert Mausbewegung in rmx, rmy und setzt dannach die Mausposition wieder zurück
  rmx += mouseX-width/2;  
  rmy += mouseY-height/2;
  if (rmx>width)rmx=0;
  if (rmx<0)rmx=width;
  if (rmy>height-1)rmy=height-1;
  if (rmy<1)rmy=1;
  robot.mouseMove(                    //setzt Cursor wieder in Mittelpunkt
    frame.getX()+round(width/2), 
    frame.getY()+round(height/2));
}

void zentrieren() {
  auge = initauge.copy();

  float phi, deta;
  PVector richt, zentrum;

  zentrum = initcenter.copy();
  richt = zentrum.sub(auge);          
  phi= atan2(richt.y, richt.x);
  rmx = map(phi, -PI, PI, 0, width);

  deta = acos(richt.z/richt.mag());
  rmy = map(deta, 0, PI, 0, height ); 
  robot.mouseMove(
    frame.getX()+round(width/2), 
    frame.getY()+round(height/2));
}