import processing.serial.*;
Serial myPort;
boolean firstContact = false;

float yaw, pitch, roll, distance, hole;
int [] irSensor = new int [40];
String[] data = new String[5];
byte msgArduino = 5;
byte oldMessage = 5;


void serialEvent (Serial myPort) {

  String inString = myPort.readStringUntil('\n');
  if (inString != null)                                //stellt ersten Kontakt her
  {
    println(inString);
    if (firstContact == false) {
      inString = trim(inString);
      if (inString.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write('4');
        println("contact");
      }
    } else {
      
      //Kontakt hergestellt, SENDET
      println(inString);
      if (msgArduino!=oldMessage) 
      {                          
        if (msgArduino==1) {
          myPort.write('1');
        }
        if (msgArduino==2) {
          myPort.write('2');
        }
        if (msgArduino==3) {
          myPort.write('3');
        }
        if (msgArduino==4) {
          myPort.write('4');
        }
        if (msgArduino==5) {
          myPort.write('5');
        }
        oldMessage=msgArduino;
      }


      // LIEST Daten ein
      try {
        String[] data = splitTokens(inString, "q");
       // println("YAW: "+data[0]);
        yaw = float(data[0]);
      //  println("ROLL: "+data[1]);
      //  println("PITCH: "+data[2]);
        roll = float(data[1]);
        pitch = float(data[2]);
        distance = float(data[3]);
        hole = float(data[4]);
       // println("distance: "+data[3]);
      //  println("hole: "+data[4]);
       
      } //try
      catch (Exception e) {
        e.printStackTrace();
      }//catch
    }
  }
}


//https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing/