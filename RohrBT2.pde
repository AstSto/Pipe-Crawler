ArrayList<RobPoint> points = new ArrayList<RobPoint>();
boolean init = false;
float ds=0; // delta Strecke des Motor - Encoders
float beta; // Winkel der vom Senorkranz  kommt
float teta;
float phi=0;
float phiinit=0;
PVector dVec;
PVector pos, dir;
int i;
float x=0;
float y=0;
float z=0;
boolean stop=false;


void drawRobot () {            // wird regelmäßig automatisch aufgerufen
  lights();
  background(255, 255, 255);
  
  if (stop==false){
  roboterposfullen();              // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt
  }
  updateCamera();         // Aktualiesiert die Camera Position
  coordAxis();            // zeichnet den Koordinaten Ursprung
  raster();      // zeichnet ein Raster ein

  pushMatrix();              //speichert derzeitiges Koordinatensystem
  // translate(500, 2500, 500);        //AUSKOMMENTIEREN BEI ANWENDUNG
  rohrzeichnen();          // zeichnet das Rohr auf der Grundlage der Arrayliste
  lochzeichnen();
  popMatrix();

  //println(frameRate);
}  //drawRobot


void roboterposfullen() {        // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt


  if (init==false) {
    phiinit=yaw;
    init = true;
  }

  println("pitch: "+pitch);
  println("roll: "+roll);
  println("yaw: "+yaw);

  teta=roll;
  phi=yaw-phiinit;
  ds=distance;
  println(ds);

  //******************************************
  //hier werden die Werte der Sensoren gefüllt 
  //******************************************
  /*ds = 10;
   phi = 70 *TWO_PI/360;
   teta = 70*TWO_PI/360;*/

  // Umrechnung der Kugelkoordinaten in karthesische Koordinaten
  x = ds * cos(teta)*cos(phi);
  y = ds * cos(teta)*sin(phi);
  z = ds * sin(teta);

  dVec = new PVector(x, y, z);
  pos.add(dVec);
  points.add(new RobPoint(pos, 100)); 

  dirbestimmen();        // bestimmt zu jedem Rohrmittelpunkt die Richtung in die dieser "schaut"

  // falls Loch gefunden wird: (hier noch zufällig)
  if (points.size() == 20) {
    RobPoint point;
    point =  points.get(points.size()-4);
    point.loch = true;
    point.lochwinkel = 40 * TWO_PI / 360;
  }

  if (points.size() == 40) {
    RobPoint point;
    point =  points.get(points.size()-4);
    point.loch = true;
    point.lochwinkel = 0 * TWO_PI / 360;
  }
}

void dirbestimmen() {                        // bestimmt zu jedem Rohrmittelpunkt die Richtung in die dieser "schaut"
  for (int i = 1; i < points.size(); i++) {
    dir = points.get(i).pos.copy();          //sucht i.te Objekt aus points und nimmt das Attribut pos raus -> Vektor wird in dir-Vektor kopiert
    dir.sub(points.get(i-1).pos);
    dir.normalize();                          //Betrag=1 mit gleicher Richtung
    points.get(i-1).dir = dir.copy();        //speichert eben ausgerechnete Richtung in das Element
    points.get(i).dir = dir.copy();
  }
}

void rohrzeichnen() {              // zeichnet das Rohr auf der Grundlage der Arrayliste
    fill(205, 91, 69);
    noStroke();                       // Ecklinien nicht mit zeichnen --> erhöht Performance deutlich
    //stroke(0);
    beginShape(QUADS);                            // es werden immer 4 Vertex Punkte zu einer Fläche zusammengefasst siehe PShape
    for (int i = 1; i < points.size(); i++) {
      RobPoint prevpoint = points.get(i-1);        // herausfinden des aktuellen und dem vorherigen Punkt
      RobPoint newpoint = points.get(i);          
      PVector xnew, ynew, xprev, yprev, up;
      up = new PVector(0, 0, 1);
      up.normalize();
      xnew = up.cross(newpoint.dir);            // neue X-Achse für newpoint, wird später benötigt um einen Kreis um den Mittelpunkt zu berechnen
      ynew = xnew.cross(newpoint.dir);          // neue Y-Achse für newpoint (Z-Achse dir Vektor)
      xnew.normalize();
      ynew.normalize();
      xprev = up.cross(prevpoint.dir);          // neue X-Achse des alten Punktes
      yprev = xprev.cross(prevpoint.dir);      // neue Y-Achse des alten Punktes
      xprev.normalize();
      yprev.normalize();

      int anzEcken = 180;                              //(bei 4 wäre das Rohr rechteckig)
      for (int j = 0; j <= anzEcken; j ++) {          // hier werden nun j iteriert entspricht dem Winkel phi 
        PVector zw;                                    //(Zwischenspeicher)
        float phi = (j*(360/anzEcken)*TWO_PI)/360;    // dem j (Eckpunkt) entsprechendem Winkel in rad z.B. mit anzEcken = 4 ist phi [0,90,180,270,360]


        zw = Ecke(newpoint.pos, xnew, ynew, newpoint.rad, phi);  // function Ecke bestimmt den Eckpunkt aus dem Mittelpunkt, dessen x,y Achse, dem Radius und dem Winkel
        vertex(zw.x, zw.y, zw.z);                                // der 1. Punkt der Rechteckigen Fläche
        zw = Ecke(newpoint.pos, xnew, ynew, newpoint.rad, phi+((360/anzEcken)*TWO_PI)/360);      //springt zum nächsten Eckpunkt durch phi+...
        vertex(zw.x, zw.y, zw.z);
        zw = Ecke(prevpoint.pos, xprev, yprev, prevpoint.rad, phi+((360/anzEcken)*TWO_PI)/360);
        vertex(zw.x, zw.y, zw.z);
        zw = Ecke(prevpoint.pos, xprev, yprev, prevpoint.rad, phi);
        vertex(zw.x, zw.y, zw.z);                                        // nach dem 4. Punkt ist die Fläche komplett und der 5. beginnt automatisch eine neue Fläche
      }
    }
    endShape();        // beendet alle Flächen


    // Start und Endpunkt beschriften:
    if (showText) {
      pushMatrix();
      fill(255, 0, 0);
      rotateX(PI*3/2);        // 270° dadurch: x' = x y'= -z z' = y  (damit Schrift in x-z-Ebene statt x-y-Ebene liegt)
      int x, y, z;
      x=round(points.get(0).pos.x+points.get(0).rad);   
      y=-round(points.get(0).pos.z);
      z=round(points.get(0).pos.y);
      text("Start bei: "+points.get(0).pos, x, y, z);              //Startpunkt der Schrift
      x= round(points.get(points.size()-1).pos.x+points.get(points.size()-1).rad);
      y=-round(points.get(points.size()-1).pos.z);
      z=round(points.get(points.size()-1).pos.y);
      text("Ende bei: "+points.get(points.size()-1).pos, x, y, z);
      PVector resultat= points.get(points.size()-1).pos.copy();
      resultat.sub(points.get(0).pos);
      text("Resultierender Vektor : "+resultat, x, y+100, z);
      popMatrix();
    }
  
}

PVector Ecke(PVector posr, PVector x, PVector y, float r, float phi ) {
  PVector zwpos, zwx, zwy;
  zwpos = posr.copy();
  zwx= x.copy();
  zwx.mult(r*cos(phi));        //Eckpunktprojektion auf x-Achse          
  zwpos.add(zwx);              // entspricht im 2D: P = P + r*cos(phi)
  zwy= y.copy();
  zwy.mult(r*sin(phi));         // entspricht im 2D: P = P + r*sin(phi)     
  zwpos.add(zwy);      

  return zwpos;
}

void raster() {

  int max = 10;                                  //Linien des Rasters
  int scl = 250;                                 //Schrittweite
  fill(0);
  stroke(0);
  for (int i = 0; i < max; i++ ) {                //senkrechte Linien x-z-Ebene - parallel zur z-Achse)
    //stroke(0, 0, 255);
    line(i*scl, 0, 0, i*scl, 0, (max-1)*scl);      //Linie(Startpunkt, Endpunkt)
    //stroke(0, 255, 0);
    line(i*scl, 0, 0, i*scl, (max-1)*scl, 0);
  }
  for (int i = 0; i < max; i++ ) {
    //stroke(0, 0, 255);
    line(0, i*scl, 0, 0, i*scl, (max-1)*scl);
    //stroke(255, 0, 0);
    line(0, i*scl, 0, (max-1)*scl, i*scl, 0);
  }
  for (int i = 0; i < max; i++ ) {
    //stroke(0, 255, 0);
    line(0, 0, i*scl, 0, (max-1)*scl, i*scl);
    //stroke(255, 0, 0);
    line(0, 0, i*scl, (max-1)*scl, 0, i*scl);
  }

  // Achsenbeschriftung
  if (showText) {
    pushMatrix();
    rotateX(PI*3/2);
    text("X-Achse", max*scl, 0, 0);
    rotateY(PI/2);
    text("Y-Achse", -max*scl-300, 0, 0);
    popMatrix();

    pushMatrix();
    rotateX(PI*3/2);
    text("Z-Achse", 0, -max*scl, 0);
    popMatrix();


    textSize(50);
    pushMatrix();
    rotateX(PI*3/2);
    for (int i = 1; i < max; i++ ) {     // Achsen-Skala      Werte (zB 250) erst an x,y,z, dann nächster Wert an x,y,z etc
      // dadurch: x' = x y'= -z z' = y
      text(i*scl, i*scl, 0, 0);        // x - Achse
      text(i*scl, 0, -i*scl, 0);       // y - Achse
      pushMatrix();
      rotateY(PI/2);
      text(i*scl, -i*scl, 0, 0);
      popMatrix();
    }
    popMatrix();
    textSize(80);
  }
}

void lochzeichnen() {           // zeichnet alle Löcher
  for (RobPoint point : points) {      // FOR EACH Schleife
    if (point.loch) {              // falls ein Loch erkannt wurde



      PVector xnew, ynew, z, up, lochpos, nullvec, zw, lochv, xkreuz, ykreuz;
      nullvec = new PVector (0, 0, 0);
      up = new PVector(0, 0, 1);
      z = point.dir;
      ynew = up.cross(z);            // neue Y-Achse 
      ynew.normalize();
      xnew = z.cross(ynew);          // neue X-Achse  jeweils zum bestimmen der Lochposition
      xnew.normalize();
      lochpos = Ecke(point.pos, xnew, ynew, point.rad, point.lochwinkel).copy();

      // neues Koordinatensystem das Tagential an das Rohr liegt
      lochv = lochpos.copy();
      lochv.sub(point.pos);
      lochv.normalize();
      ykreuz = up.cross(lochv);
      ykreuz.normalize();
      xkreuz = lochv.cross(ykreuz);
      xkreuz.normalize();

      fill(255, 0, 0);

      // zeichnen des Kreuzes 
      pushMatrix();
      translate(lochpos.x, lochpos.y, lochpos.z);
      beginShape();
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(10)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(170)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(190)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(-10)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      endShape(CLOSE);

      beginShape();
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(80)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(100)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(260)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      zw = Ecke(nullvec, xkreuz, ykreuz, point.rad, radians(280)).copy(); 
      vertex(zw.x, zw.y, zw.z);
      endShape(CLOSE);

      popMatrix();
    }
  }
}

void coordAxis() {                // zeichnet Koordinatenursprung ein
  stroke(255, 0, 0);
  line(0, 0, 0, 500, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 500, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 500);
} 