/* //<>//
TO DO:
 Processing -> Arduino
 1 Byte senden
 Modus übertragen (Mapping, Schnelligkeit, DEtektion, Licht für GoPro, Notaus)
 
 Arduino -> Processing
 Daten:
 Winkel x,y,z
 Distanz
 Loch [40Werte]
 (Voltage -> Akkustand anzeigen lassen)
 Rückmeldung, ob Bluetooth gekoppelt ist
 
 Legende Shortcuts
 Rohr transparent, innen Linie rot
 Kreuze für Löcher
 */


//Testfunktion, welche die 3 Winkel anzeigen soll
void showValues() {
  serialEvent(myPort);
  background(218, 218, 218); //grey
  font = createFont("Arial", 14);
  fill(0);
  textSize(70);
  textSize(40);
  textAlign(LEFT);
  text("yaw "+yaw, 350, 300);
  text("pitch "+pitch, 350, 400);
  text("roll "+roll, 350, 500);
  //
} // func

void kreuz(int x, int y, int z) {
  strokeWeight(4);
  stroke(0, 0, 255);
  // stroke (255,153,0); //orange
  // stroke (153,0,204); //lila
  line (x-20, y, z-20, x+20, y, z+20);
  line (x, y-20, z-20, x, y+20, z+20);
  strokeWeight(1);
}