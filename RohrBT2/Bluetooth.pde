import processing.serial.*;

Serial myPort;
//boolean firstContact = false;

float yaw, pitch, roll;
int [] irSensor = new int [40];
String[] data = new String[3];
int oldMessage = 0;

void serialEvent (Serial myPort) {
  // get the ASCII string:

  String inString = myPort.readStringUntil('\n');
  println("Ankommender String "+inString);
  if (inString != null)
  {
    try {
      String[] data = splitTokens(inString, "q");
      println("YAW: "+data[0]);
      yaw = float(data[0]);
      println("ROLL: "+data[1]);
      println("PITCH"+data[2]);
      roll = float(data[1]);
      pitch = float(data[2]);
    } 
    catch (Exception e) {
      //
      e.printStackTrace();
    }

    /*if (firstContact == false) {
     if (val.equals("A")) {
     myPort.clear();
     firstContact = true;
     myPort.write("A");
     println("contact");
     }
     } else { //if we've already established contact, keep getting and parsing data
     */
    if (msgArduino!=oldMessage) 
    {                           //if we clicked in the window
      myPort.write(msgArduino);
      oldMessage = msgArduino;
    }

    // when you've parsed the data you have, ask for more:
    //myPort.write('A');
    // }
  }
}


/*
   void sendToArduino(){
 // String msg = status + "|" + status1 + "|" + status2 + "|" + status3;
 if (msgArduino!=oldMessage) {      //falls sich die Werte und somit die Nachricht nicht geändert haben, wird nichts gesendet.
 //port.write("|");     //setzt ersten header
 myPort.write(msgArduino);
 oldMessage = msgArduino;
 }
 */



/*String inString = myPort.readStringUntil('\n');
 if (inString != null)
 {
 inString = trim(inString);
 String[] data = inString.split("q");
 pitch = float(data[0]);
 yaw = float(data[1]);
 roll = float(data[2]);
 }
 // convert to a number.
 //if*/