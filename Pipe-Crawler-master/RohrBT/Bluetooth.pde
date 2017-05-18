import processing.serial.*;

Serial myPort;
float yaw, pitch, roll;

void serialEvent (Serial myPort) {
// get the ASCII string:


 for (int i=0; i<3; i++){ 
   String inString = myPort.readStringUntil('\n');
    if (inString != null)
    {
        inString = trim(inString); // trim off whitespaces.
        
        if (i==0) {pitch = float(inString);}
        if (i==1){ yaw = float(inString);}
        if (i==2) {roll = float(inString);} // convert to a number.
    }//if
 }//for
}