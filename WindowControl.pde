// states
final int stateMenu                  = 0;
final int stateSeeControl            = 7;
final int stateSeeAnalysis           = 8;
final int stateLochdetektion         = 9;
int state = stateMenu;              //default screen
boolean connected;
PFont font;

// ----------------------------------------------------------------------
// main functions
void settings()
{
  fullScreen(P3D, 1);
}

void setup()
{
  // textMode(SHAPE);
  textSize(80);
  smooth();
  //textFont(font);

  //bluetooth--------------------------------------------------------------------------------------------
  try {                   
    myPort = new Serial(this, "COM5", 9600); // port used by bluetooth shield
    // A serialEvent() is generated when a newline character is received :
    myPort.bufferUntil('\n');
    connected = true;
  }  
  catch(Throwable e) {
    connected = false;
  }



  initCamera();            // initialisiert die Camera

  pos = new PVector(0, 0, 0);     // initialisiert den ersten Roboterpunkt (wird später überschrieben)
  dir = new PVector(1, 0, 0);
  //roboterposfullen();              // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt
} //setup

int oldState = -1;
void draw()
{
  // the main routine handels the states
  if (state != oldState) {
    //println("new State = " + state);
    oldState = state;
  }
  switch (state) {
  case stateMenu:
    showMenu();
    break;
  case stateSeeControl:
    handleStateSeeControl();
    break;
  case stateSeeAnalysis:
    handleStateSeeAnalysis();
    break;
  case stateLochdetektion:
    handleLochdetektion();
    break;
  default:
    // println ("Unknown state (in draw) "+ state+ " ++++++++++++++++++++++");
    exit();
    break;
  } // switch
} // draw

// keyboard functions---------------------------------------------------------

void keyPressed() {
  // keyboard. Also different depending on the state.
  switch (state) {
  case stateMenu:
    keyPressedForStateMenu();
    break;
  case stateSeeControl:
    keyPressedForStateSeeControl();
    break;
  case stateSeeAnalysis:
    keyPressedForStateSeeAnalysis();
    keyPressedCamera();
    break;
  case stateLochdetektion:
    keyPressedForLochdetektion();
    break;
  default:
    //println ("Unknown state (in keypressed) "+ state + " ++++++++++++++++++++++");
    exit();
    break;
  } // switch
} // func key pressed

void keyPressedForStateMenu() {
  //println("pressed key: " + key + " in menu");

  switch(key) {
  case '7':
    state = stateSeeControl;
    break;
  case '8':
    state = stateSeeAnalysis;
    break;
  case '9':
    state = stateLochdetektion;
    break;
  case 'n':
    msgArduino=5;
    break;
  }// switch
} // func

void keyPressedForStateSeeControl() {
  //println("pressed key: " + key + " in control");

  switch(key) {
  case '0':
    state = stateMenu;
    break;
  case '8':
    state = stateSeeAnalysis;
    break;
  case '9':
    state = stateLochdetektion;
    break;
  case '1':
    msgArduino=1;
    //sendToArduino();
    break;  
  case '2':
    msgArduino=2;
    //sendToArduino();
    break;  
  case '3':
    msgArduino=3;
    //sendToArduino();
    break;
  case '4':
    msgArduino=4;
    break;
  case 'n':
    msgArduino=5;
    break;
  default:
    // do nothing
    break;
  }
  //
} // func

void keyPressedForStateSeeAnalysis() {  
  // println("pressed key: " + key + " in analysis");
  switch(key) {
  case '0':
    state = stateMenu;
    break;
  case '7':
    state = stateSeeControl;
    break;
  case '9':
    state = stateLochdetektion;
    break;
  case 'n':
    msgArduino=5;
    break;
  default:
    // do nothing
    break;
  } // switch
} // func

void keyPressedForLochdetektion() {
  //println("pressed key: " + key + " in Lochdedection");
  switch(key) {
  case '0':
    state = stateMenu;
    break;
  case '7':
    state = stateSeeControl;
    break;
  case '8':
    state = stateSeeAnalysis;
    break;
  case 'n':
    msgArduino=5;
    break;
  default:
    // do nothing
    break;
  } // switch
} // func


// ----------------------------------------------------------------
// functions to show the menu and functions that are called from the menu.
// They depend on the states and are called by draw().

void showMenu() {
  background(218, 218, 218); //grey
  font = createFont("Arial", 14);
  fill(0);
  textSize(60);
  textAlign(CENTER);
  text(" Main Menu ", width/2, 150);
  textSize(40);
  textAlign(LEFT);
  text("7 = Arduino Control", 350, 300);
  text("8 = Window Mapping ", 350, 350);
  text("9 = Window Hole Detection ", 350, 400);

  text("0 = return here", 350, 500);
  text("Esc = quit ", 350, 650);
  //
} // func

void handleStateSeeControl() {
  //saveFrame("output/control####.png");  //macht eine Bildsequenz
  background(192, 192, 192);  //grey
  fill(0);
  textSize(70);
  textAlign(CENTER);
  text(" Control ", width/2, 100);
  textSize(20);
  text("1 = Arduino Modus 1", width/2, 600);
  text("2 = Arduino Modus 2", width/2, 630);
  text("3 = Arduino Modus 3", width/2, 660);
  text("4 = Arduino Kalibration", width/2-10, 690);
  textSize(40);
  textAlign(RIGHT);
  text("STOP", width/2, 300);
  text ("Battery", width/2, 400);
  text ("actual Modus:", width/2, 500);
  if (msgArduino==5) {
    text (" off", width/2+70, 500);
  } else {
    text (+msgArduino, width/2+30, 500);
  }
  //  text("Bluetooth Connection", width/2, 500);
  //fill(0, 255, 0);
  //ellipse(width/2+40, 485, 50, 50);
  fill(255, 0, 0);
  rect(width/2+20, 250, 150, 80);
  fill(255);
  text("press n", width/2+155, 300);
  textAlign(LEFT);
  //
} // func
//

void handleStateSeeAnalysis() {
  pushMatrix();
  drawRobot();
  popMatrix();
} // func

void handleLochdetektion() {
  showValues();
  //  redraw();
} //func  
// ----------------------------------------------------------------
//
//Chrisir - https://forum.processing.org/one/topic/i-need-create-menu.html