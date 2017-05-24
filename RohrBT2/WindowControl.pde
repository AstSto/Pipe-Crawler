// states
final int stateMenu                  = 0;
final int stateSeeControl            = 1;
final int stateSeeAnalysis           = 2;
final int stateLochdetektion         = 3;
char msgArduino                      = 0;
int state = stateMenu;              //default screen

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
  myPort = new Serial(this, "COM5", 9600); // port used by bluetooth shield
  // A serialEvent() is generated when a newline character is received :
  myPort.bufferUntil('\n');


  initCamera();            // initialisiert die Camera

  pos = new PVector(0, 0, 0);     // initialisiert den ersten Roboterpunkt (wird später überschrieben)
  dir = new PVector(1, 0, 0);
  roboterposfullen();              // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt
} //setup

int oldState = -1;
void draw()
{
  //sendToArduino();
  // the main routine handels the states
  if (state != oldState) {
    println("new State = " + state);
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
    println ("Unknown state (in draw) "+ state+ " ++++++++++++++++++++++");
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
    println ("Unknown state (in keypressed) "+ state + " ++++++++++++++++++++++");
    exit();
    break;
  } // switch
} // func key pressed

void keyPressedForStateMenu() {
  println("pressed key: " + key + " in menu");

  switch(keyCode) {
  case ENTER:
    msgArduino=0;
    //sendToArduino();
    break;
  }
  switch(key) {
  case '1':
    state = stateSeeControl;
    break;
  case '2':
    state = stateSeeAnalysis;
    break;
  case '3':
    state = stateLochdetektion;
    break;
  }// switch
} // func

void keyPressedForStateSeeControl() {
  println("pressed key: " + key + " in control");

  switch(keyCode) {
  case ENTER:
    msgArduino=0;
    // sendToArduino();
    break;
  }

  switch(key) {
  case '0':
    state = stateMenu;
    break;
  case '2':
    state = stateSeeAnalysis;
    break;
  case '3':
    state = stateLochdetektion;
    break;
  case '5':
    msgArduino=1;
    //sendToArduino();
    break;  
  case '6':
    msgArduino=2;
    //sendToArduino();
    break;  
  case '7':
    msgArduino=3;
    //sendToArduino();
    break;
  case '4':
    msgArduino=4;
    break;
  default:
    // do nothing
    break;
  }
  //
} // func
void keyPressedForStateSeeAnalysis() {
  switch(keyCode) {
  case ENTER:
    msgArduino=0;
    // sendToArduino();
    break;
  }    
  println("pressed key: " + key + " in analysis");
  switch(key) {
  case '0':
    state = stateMenu;
    break;
  case '1':
    state = stateSeeControl;
    break;
  case '3':
    state = stateLochdetektion;
    break;
  default:
    // do nothing
    break;
  } // switch
} // func

void keyPressedForLochdetektion() {
  println("pressed key: " + key + " in Lochdedection");
  switch(keyCode) {
  case ENTER:
    msgArduino=0;
    //sendToArduino();
    break;
  }  
  switch(key) {
  case '0':
    state = stateMenu;
    break;
  case '1':
    state = stateSeeControl;
    break;
  case '2':
    state = stateSeeAnalysis;
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
  text("Press 1 for Control window ", 350, 300);
  text("Press 2 for Window Mapping ", 350, 350);
  text("Press 3 for Window Hole Detection ", 350, 400);

  text("Press 0 to return here", 350, 500);
  text("Press ESC to quit ", 350, 650);
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
  text("Press 4 for Arduino RESET", width/2-10, 600);
  text("Press 5 for Arduino modus 1", width/2, 630);
  text("Press 6 for Arduino modus 2", width/2, 660);
  text("Press 7 for Arduino modus 3", width/2, 690);
  textSize(40);
  textAlign(RIGHT);
  text("STOP", width/2, 300);
  text ("Battery", width/2, 400);
  text ("Modus", width/2, 500);
  text (+msgArduino, width/2+30, 500);
  //  text("Bluetooth Connection", width/2, 500);
  //fill(0, 255, 0);
  //ellipse(width/2+40, 485, 50, 50);
  fill(255, 0, 0);
  rect(width/2+20, 250, 150, 80);
  fill(255);
  text("ENTER", width/2+155, 300);

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