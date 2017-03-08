ArrayList<RobPoint> points = new ArrayList<RobPoint>();

PVector pos, dir;
int i;

 void setup () {          // diese Funktion wird einmalig bei Start aufgerufen
  fullScreen(P3D);        
  initCamera();            // initialiesiert die Camera
  colorMode(RGB, 1);
  pos = new PVector(0, 0, 0);     // initialiesiert den ersten Roboterpunkt (wird später überschrieben)
  dir = new PVector(1, 0, 0);
  roboterposfullen();              // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt
}


void draw () {            // wird regelmäßig automatisch aufgerufen
  lights();
  background(0);
  updateCamera();         // Aktualiesiert die Camera Position
  coordAxis();            // zeichnet den Koordinaten Ursprung
  rohrzeichnen();          // zeichnet das Rohr auf der Grundlage der Arrayliste
  //box(100);
  //wurfel();
}

void roboterposfullen() {        // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt
  PVector sp;                    // anstatt von Simulierten Werten hier die echten Roboterpositionen verwenden!
  pos = new PVector(0, 0, 0);
  for (int i = 0; i<10; i++) {
    pos = new PVector(300*cos(i*20*TWO_PI/360), 300*sin(i*20*TWO_PI/360), 0);
    points.add(new RobPoint(pos, 100));                                        // in die Liste points werden Objekte( mit Rohrmittelpunkt und Radius) gespeichert
  }
  for (int i = 1; i<10; i++) {                                   // mehrere Beispielhafte Punkte
    pos.y -= i*20;
    points.add(new RobPoint(pos, 80));
  }
  sp = pos.copy();
  for (int i = 1; i<7; i++)
  {
    pos.x = sp.x;
    pos.y = sp.y-400*sin(i*10*TWO_PI/360);
    pos.z = sp.z+400-400*cos(i*10*TWO_PI/360);
    points.add(new RobPoint(pos, 50));
  }
  dirbestimmen();        // bestimmt zu jedem Rohrmittelpunkt die Richtung in die dieser "schaut"
}

void dirbestimmen() {                        // bestimmt zu jedem Rohrmittelpunkt die Richtung in die dieser "schaut"
  for (int i = 1; i < points.size(); i++) {
    dir = points.get(i).pos.copy();
    dir.sub(points.get(i-1).pos);
    dir.normalize();
    points.get(i-1).dir = dir.copy();
    points.get(i).dir = dir.copy();
  }
}

void rohrzeichnen() {              // zeichnet das Rohr auf der Grundlage der Arrayliste

  //fill(0,0,1,0.1);                // hier kann Füllfarbe und Alpha wert eingestellt werden
  noStroke();                       // Ecklinien nicht mit zeichnen --> erhöht Performance deutlich
  beginShape(QUADS);                            // es werden immer 4 Vertex Punkte zu einer Fläche zusammengefasst siehe PShape
  for (int i = 1; i < points.size(); i++) {
    RobPoint prevpoint = points.get(i-1);        // herausfinden des aktuellen und dem vorherigen Punkt
    RobPoint newpoint = points.get(i);          
    PVector xnew, ynew, xprev, yprev, up;
    up = new PVector(0, 0, 1);
    up.normalize();
    xnew = up.cross(newpoint.dir);            // neue X-Achse für newpoint, wird später benötigt um einen Kreis um den Mittelpunkt zu berechnen
    ynew = xnew.cross(newpoint.dir);          // neue Y-Achse für newpoint
    xnew.normalize();
    ynew.normalize();
    xprev = up.cross(prevpoint.dir);          // neue X-Achse des alten Punktes
    yprev = xprev.cross(prevpoint.dir);      // neue Y-Achse des alten Punktes
    xprev.normalize();
    yprev.normalize();

    int anzEcken = 18;
    for (int j = 0; j <= anzEcken; j ++) {          // hier werden nun j iteriert entspricht dem Winkel phi 
      PVector zw;
      float phi = (j*(360/anzEcken)*TWO_PI)/360;    // dem j entsprechendem Winkel z.B. mit anzEcken = 4 ist phi [0,90,180,270,360]


      zw = Ecke(newpoint.pos, xnew, ynew, newpoint.rad, phi);  // function Ecke bestimmt den Eckpunkt aus dem Mittelpunkt, dessen x,y Achse, dem Radius und dem Winkel
      vertex(zw.x, zw.y, zw.z);                                // der 1. Punkt der Rechteckigen Fläche
      zw = Ecke(newpoint.pos, xnew, ynew, newpoint.rad, phi+((360/anzEcken)*TWO_PI)/360);
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(prevpoint.pos, xprev, yprev, prevpoint.rad, phi+((360/anzEcken)*TWO_PI)/360);
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(prevpoint.pos, xprev, yprev, prevpoint.rad, phi);
      vertex(zw.x, zw.y, zw.z);                                        // nach dem 4. Punkt ist die Fläche komplett und der 5. beginnt automatisch eine neue Fläche
    }
  }
  endShape();        // beendet alle Flächen
}

PVector Ecke(PVector posr, PVector x, PVector y, int r, float phi ) {
  PVector zwpos, zwx, zwy;
  zwpos = posr.copy();
  zwx= x.copy();
  zwx.mult(r*cos(phi));          
  zwpos.add(zwx);              // entspricht im 2D: P = P + r*cos(phi)
  zwy= y.copy();
  zwy.mult(r*sin(phi));         // entspricht im 2D: P = P + r*sin(phi)     
  zwpos.add(zwy);

  return zwpos;
}


void wurfel () {                    // nur ein Beispiel welches die Funktion fill() und Vertex verdeutlicht
  beginShape(QUADS);

  fill(0, 1, 1); 
  vertex(-100, 100, 100);
  fill(1, 1, 1); 
  vertex( 100, 100, 100);
  fill(1, 0, 1); 
  vertex( 100, -100, 100);
  fill(0, 0, 1); 
  vertex(-100, -100, 100);

  fill(1, 1, 1); 
  vertex( 100, 100, 100);
  fill(1, 1, 0); 
  vertex( 100, 100, -100);
  fill(1, 0, 0); 
  vertex( 100, -100, -100);
  fill(1, 0, 1); 
  vertex( 100, -100, 100);

  fill(1, 1, 0); 
  vertex( 100, 100, -100);
  fill(0, 1, 0); 
  vertex(-100, 100, -100);
  fill(0, 0, 0); 
  vertex(-100, -100, -100);
  fill(1, 0, 0); 
  vertex( 100, -100, -100);

  fill(0, 1, 0); 
  vertex(-100, 100, -100);
  fill(0, 1, 1); 
  vertex(-100, 100, 100);
  fill(0, 0, 1); 
  vertex(-100, -100, 100);
  fill(0, 0, 0); 
  vertex(-100, -100, -100);

  fill(0, 1, 0); 
  vertex(-100, 100, -100);
  fill(1, 1, 0); 
  vertex( 100, 100, -100);
  fill(1, 1, 1); 
  vertex( 100, 100, 100);
  fill(0, 1, 1); 
  vertex(-100, 100, 100);

  fill(0, 0, 0); 
  vertex(-100, -100, -100);
  fill(1, 0, 0); 
  vertex( 100, -100, -100);
  fill(1, 0, 1); 
  vertex( 100, -100, 100);
  fill(0, 0, 1); 
  vertex(-100, -100, 100);

  endShape();
}

void coordAxis() {                // zeichnet Koordinatenursprung ein
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);
}