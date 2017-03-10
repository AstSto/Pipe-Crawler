// hier sind alle statischen 3D Objekte
boolean schrift = true;

void raster() {

  int max = 10;
  int scl = 250;
  fill(0);
  stroke(0);
  for (int i = 0; i < max; i++ ) {
    line(i*scl, 0, 0, i*scl, 0, (max-1)*scl);
    line(i*scl, 0, 0, i*scl, (max-1)*scl, 0);
  }
  for (int i = 0; i < max; i++ ) {
    line(0, i*scl, 0, 0, i*scl, (max-1)*scl);
    line(0, i*scl, 0, (max-1)*scl, i*scl, 0);
  }
  for (int i = 0; i < max; i++ ) {
    line(0, 0, i*scl, 0, (max-1)*scl, i*scl);
    line(0, 0, i*scl, (max-1)*scl, 0, i*scl);
  }

  // Achsenbeschriftung
  if (schrift) {
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
    for (int i = 1; i < max; i++ ) {     // Achsen-Skala
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

void wurfel () {                    // nur ein Beispiel welches die Funktion fill() und Vertex verdeutlicht
  beginShape(QUADS);

  fill(0, 255, 255); 
  vertex(-100, 100, 100);
  fill(255, 255, 255); 
  vertex( 100, 100, 100);
  fill(255, 0, 255); 
  vertex( 100, -100, 100);
  fill(0, 0, 255); 
  vertex(-100, -100, 100);

  fill(255, 255, 255); 
  vertex( 100, 100, 100);
  fill(255, 255, 0); 
  vertex( 100, 100, -100);
  fill(255, 0, 0); 
  vertex( 100, -100, -100);
  fill(255, 0, 255); 
  vertex( 100, -100, 100);

  fill(255, 255, 0); 
  vertex( 100, 100, -100);
  fill(0, 255, 0); 
  vertex(-100, 100, -100);
  fill(0, 0, 0); 
  vertex(-100, -100, -100);
  fill(255, 0, 0); 
  vertex( 100, -100, -100);

  fill(0, 255, 0); 
  vertex(-100, 100, -100);
  fill(0, 255, 255); 
  vertex(-100, 100, 100);
  fill(0, 0, 255); 
  vertex(-100, -100, 100);
  fill(0, 0, 0); 
  vertex(-100, -100, -100);

  fill(0, 255, 0); 
  vertex(-100, 100, -100);
  fill(255, 255, 0); 
  vertex( 100, 100, -100);
  fill(255, 255, 255); 
  vertex( 100, 100, 100);
  fill(0, 255, 255); 
  vertex(-100, 100, 100);

  fill(0, 0, 0); 
  vertex(-100, -100, -100);
  fill(255, 0, 0); 
  vertex( 100, -100, -100);
  fill(255, 0, 255); 
  vertex( 100, -100, 100);
  fill(0, 0, 255); 
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