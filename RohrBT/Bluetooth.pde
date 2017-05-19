import processing.serial.*;

Serial myPort;
float yaw, pitch, roll;
String[] data = new String[6];

void serialEvent (Serial myPort) {
  // get the ASCII string:
  
     String inString = myPort.readStringUntil('\n');
     println("Ankommender String "+inString);
   if (inString != null)
   {
   try {
   String[] data = splitTokens(inString, "/");
    println("PITCH: "+data[0]);
       pitch = float(data[0]);
   println("YAW: "+data[1]);
    println("ROLL"+data[2]);
  yaw = float(data[1]);
   roll = float(data[2]);
   } 
   catch (Exception e) {
   //
   e.printStackTrace();
   }
   }
  
  
  //CODE MANUEL
  /*println("---------------start");

  println("begin: " + input + " - end");
  println("---------------end");
  for (int i = 0; i < 3; i++) {
    String input = myPort.readString();
    data[i] = input;
    //hier versuchen eine weile zu warten!
  }
  //println("data: " + data[0] + ":" + data[1] + ":" + data[2] + ":");
  if (data[0] != null) {
    pitch = float(data[0]);
  }
  if (data[1] != null) {
    yaw = float(data[1]);
  }
  if (data[2] != null) {
    roll = float(data[2]);
  }*/



  /*
   String inString = myPort.readStringUntil('\n');
   if (inString != null)
   {
   try {
   String[] data = inString.split("/");
   println("datalaenge: " + data.length);
   pitch = float(data[0]);
   yaw = float(data[1]);
   roll = float(data[2]);
   } 
   catch (Exception e) {
   //
   e.printStackTrace();
   }
   }
   */
 
  /*String inString = myPort.readStringUntil('\n');
   if (inString != null)
   {
   inString = trim(inString);
   String[] data = inString.split("/");
   pitch = float(data[0]);
   yaw = float(data[1]);
   roll = float(data[2]);
   }
   // convert to a number.
   //if*/
}