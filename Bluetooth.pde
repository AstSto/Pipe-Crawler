import processing.serial.*;

Serial myPort;
boolean firstContact = false;

float yaw, pitch, roll;
int [] irSensor = new int [40];
String[] data = new String[3];
byte oldMessage = 0;
//int zahl=3;
void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null)
  {
    /*try {
     String[] data = splitTokens(inString, "q");
     // println("YAW: "+data[0]);
     yaw = float(data[0]);
     // println("ROLL: "+data[1]);
     // println("PITCH"+data[2]);
     roll = float(data[1]);
     pitch = float(data[2]);
     } //try
     catch (Exception e) {
     //
     e.printStackTrace();
     }//catch
     }*/
    // sendMessage(msgArduino);


    inString = trim(inString);
    println(inString);
    if (firstContact == false) {
      if (inString.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
        println("contact");
      }
    } else { //if we've already established contact, keep getting and parsing data
      println(inString);
      if (msgArduino!=oldMessage) 
      {                           //if we clicked in the window
        /* //Sendefehler vermeiden -> öfter senden                                                                        -----------------------------------
         // myPort.write('|');
         byte[] asd = {1,2,3,4,5,6,7,8,9};
         //  myPort.write(msgArduino);
         myPort.write(asd);
         //myPort.write(zahl);
         //myPort.write(errorproof(msgArduino));
         oldMessage = msgArduino;*/
        myPort.write('1');        //send a 1
        println("1");
      }
    }
  }
}
/*
int errorproof(int msg) {
 int newmsg = msg;
 newmsg+=msg*8;
 return newmsg;
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
 //if */