 //<>//
//Testfunktion, welche die 3 Winkel anzeigen soll
void showValues() {
  serialEvent(myPort);
  background(218, 218, 218); //grey
  font = createFont("Arial", 14);
  fill(0);
  textSize(70);
  textSize(40);
  textAlign(LEFT);
  text("yaw "+round(yaw* 180 / 2), 350, 300);
  text("pitch "+round(pitch* 180 / 2), 350, 400);
  text("roll "+round(roll* 180 / 2), 350, 500);
  //
} // func


//Ort
//Grösse


void lochbestimmung() {
  //vorderer Sensorkranz rechts
  int summeKranz1R=0;
  for (int i=0; i<9; i++) {      //irSensor.length    muss alten Wert speichern -> (schauen, ob der alte wert wieder kleiner, gleichbleibend, oder größer wird (-> bestimmt Lochgröße)
    summeKranz1R=+irSensor[i];
  }
  if (summeKranz1R!=0) {
    //Ortsdetektion
  }

  //vorderer Sensorkranz links
  int summeKranz1L=0;
  for (int i=10; i<19; i++) {      //irSensor.length
    summeKranz1L=+irSensor[i];
  }
  if (summeKranz1L!=0) {
    //Ortsdetektion
  }

  //hinterer Sensorkranz rechts
  int summeKranz2R=0;
  for (int i=20; i<29; i++) {      //irSensor.length
    summeKranz2R=+irSensor[i];
  }

  //hinterer Sensorkranz links
  int summeKranz2L=0;
  for (int i=30; i<39; i++) {      //irSensor.length
    summeKranz2L=+irSensor[i];
  }
}//fct



void kreuz() {       //bekommt Winkel des Lochs übertragen
   strokeWeight(4);
   stroke(0, 0, 255);
   // stroke (255,153,0); //orange
   // stroke (153,0,204); //lila
   pushMatrix();
   translate(-pos.x, -pos.y, -pos.z); //schiebt es in den Mittelpunkt
   strokeWeight(1);
   popMatrix();
}