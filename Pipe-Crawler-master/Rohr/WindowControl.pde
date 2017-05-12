 //Chrisir - https://forum.processing.org/one/topic/i-need-create-menu.html
    // states
    final int stateMenu                  = 0;
    final int stateSeeControl            = 1;
    final int stateSeeAnalysis           = 2;
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
   
  initCamera();            // initialiesiert die Camera

  pos = new PVector(0, 0, 0);     // initialiesiert den ersten Roboterpunkt (wird später überschrieben)
  dir = new PVector(1, 0, 0);
  roboterposfullen();              // hier werden die Eigentlichen Roboterpunkte in eine ArrayListe umgewandelt
    } 
    
    
    void draw()
    {
      // the main routine handels the states
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
      default:
        println ("Unknown state (in keypressed) "+ state + " ++++++++++++++++++++++");
        exit();
        break;
      } // switch
    } // func key pressed
    
    void keyPressedForStateMenu() {
      switch(key) {
      case '1':
        state = stateSeeControl;
        break;
      case '2':
        state = stateSeeAnalysis;
        break;
      default:
        // do nothing
        break;
      }// switch
      //
    } // func
    void keyPressedForStateSeeControl() {
     switch(key) {
      case '0':
        state = stateMenu;
        break;
      case '2':
        state = stateSeeAnalysis;
        break;
      default:
        // do nothing
        break;
      } // switch
      //
    } // func
    void keyPressedForStateSeeAnalysis() {
      // any key is possible
      switch(key) {
      case '0':
        state = stateMenu;
        break;
      case '1':
        state = stateSeeControl;
        break;
      default:
        // do nothing
        break;
      } // switch
      //
    } // func

    // ----------------------------------------------------------------
    // functions to show the menu and functions that are called from the menu.
    // They depend on the states and are called by draw().

    void showMenu() {
      background(218, 218, 218); //grey
      font = createFont("Arial", 14);
      fill(0);
      textSize(70);
      textAlign(CENTER);
      text(" Main Menu ", width/2, 150);
      textSize(40);
      textAlign(LEFT);
      text("Press 1 for Control window ", 350, 300);
      text("Press 2 for Mapping ", 350, 400);
      //
      text("Press ESC to quit ", 350, 500);
      //
    } // func

    void handleStateSeeControl() {
      background(192, 192, 192);  //grey
      fill(0);
      textSize(70);
      textAlign(CENTER);
      text(" Control ", width/2, 100);
      textSize(40);
      textAlign(RIGHT);
      text("STOP", width/2, 300);
      text ("Battery", width/2, 400);
      text("Bluetooth Connection",width/2,500);
      fill(0,255,0);
      ellipse(width/2+40,485,50,50);
      fill(255,0,0);
      rect(width/2+20,250,100,80);      
      //
    } // func
    //

    void handleStateSeeAnalysis() {
      pushMatrix();
      drawRobot();
      popMatrix();
      
    } // func
    // ----------------------------------------------------------------
    //