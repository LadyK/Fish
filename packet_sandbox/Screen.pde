class Screen {

  PFont f;
  PVector screen_location, text_location;
  color t;

  String[] line;
  int topacity;
  int start;
  int yStart;

  Screen(PVector l, int s) {
    start = s; //location in text file
    screen_location = l.copy();
    //text_location = l.copy();
    //text_location.add(10, 10); // in and down a smidge
    text_location = new PVector(10, 30);
    // not sure what to do with this line here with reference to line vvvvv
    yStart = int(screen_location.y) + 200; //complaining about location.y being a float; OFF screen for y
    
    topacity = 100;
    t = color(75, 255, 85, topacity);
    f = createFont("Arial", 16);
    textFont(f, 24);
    textAlign(LEFT);
    fill(t);
    inputText = loadStrings("packets2_test.txt"); //leave to be global in the sketch
    linesPerScreen = 9;
    line = new String[10];
    //line = 0;
    //initalize();
  }

  int initalize() { // load the array (for screen) up with text
    //currentLineNum = s;
    //print("s is: ");
    //println(s);
    // show first 10 lines
    // take the first 10 lines and load them in to screen array
    println("loading up more text");
    int limit = start + linesPerScreen; // current lineNum + 9
    int l_num = 0; // increment marker for which line on this screen we are on
    for (int i = start; i < limit; i++) { // i used for inputText line number
      String temp = inputText[i];
      line[l_num] = temp; //new Line(i, location); //location for inputText gets passed in
      // make them visual vvvv
      text(line[i], text_location.x, text_location.y);
      text_location.y += 25;

      //screen[l_num].display();
      l_num++;
      //print("s is: ");
      //println(s);
    }
    //displayScreen();
   
    return limit;
  }

  void update(int top) {
    top++;
    if (top > 255) top = 255;
    // update scroll variables
    topacity = top;
  }

  void run() {
    //scrollUp();
   // for (int i = 0; i < linesPerScreen; i++) {
      //screen[i].scrollUp();
      displayScreen(topacity);
   // }
  }

  void scrollUp() {
    //topacity++;
    //if (topacity>255) topacity = 255;
    //fill(t, topacity);



    // move up and then show the next lines that are hidden (scrolling)
    int maxPortHeight = linesPerScreen * 25 + 10;
    for (int y_ = yStart; y_ < maxPortHeight; y_+= 25) {
      screen_location.y = y_;
      /*******
       for this for-loop to work, we must draw the text inside the loop.
       Or, we do the manipulation of the y, elsewhere
       Perhaps, place this in the Line class?
       
       ********/
      //text(screen[line], location.x, location.y);
      //   if (line < linesPerScreen) {
      //    line++;
      //print("line number for scroll: ");
      //println(line);
      //  } else if (line == linesPerScreen) {
      // println("LINES MORE THAN LINESPERSCREEN");
      //println("getting new line");
      //print("currentLineNum is: ");
      //println(currentLineNum);

      //*****vvvvv
      //cln = cln+10;
      //initalize(cln);
      //line = 0;
      //  }
    }
    yStart--;
  }

  void displayScreen(int top_) {
    fill(t, top_);
    //x = 0;
    pushMatrix();
    translate(screen_location.x,screen_location.y);
    //println(line[8]);
    for (int i = 0; i < line.length-1; i++) { //last spot in array is empty due to initalize()'s for-loop structure
      //screen[i].scrollUp();
      //screen[i].display();
      text(line[i], text_location.x, text_location.y);
      //x += textWidth(screen[y]);
      //x++;
       text_location.y+= 25; //***** issue here, no? just want the text scrolling up, once it's appeared
    }
    //if (frameCount %28 == 0) {
    //  y--;
    //}
    popMatrix();
  } // displayScreen
  
  
} //class
