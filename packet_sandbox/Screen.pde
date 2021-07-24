class Screen {

  //PFont f;
  PVector location;
  color t;

  Line[] screen;
  int topacity;
  int start;
  int yStart;

  Screen(PVector l, int s) {
    start = s; //location in text file
    location = l.copy();
    yStart = int(location.y) + 200; //complaining about location.y being a float; OFF screen for y
    // topacity = 100;
    t = color(75, 255, 85, topacity);
    //f = createFont("Arial", 16);
    //textFont(f, 24);
    //textAlign(LEFT);
    //fill(t);
    //inputText = loadStrings("packets2_test.txt"); //leave to be global in the sketch
    linesPerScreen = 9;
    screen = new Line[10];
    //line = 0;
  }

  int initalize() {
    //currentLineNum = s;
    //print("s is: ");
    //println(s);
    // show first 10 lines
    // take the first 10 lines and load them in to screen array
    println("loading up more text");
    int limit = start + linesPerScreen; // current lineNum + 9
    int l_num = 0; // increment marker for which line on this screen we are on
    for (int i = start; i < limit; i++) { // i used for inputText line number
      //String temp = inputText[i];
      screen[l_num] = new Line(i, location); //location for inputText gets passed in
      location.y += 25;
      fill(t);
      screen[l_num].display();
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
    for (int i = 0; i < linesPerScreen; i++) {
      //screen[i].scrollUp();
      //displayScreen(topacity);
    }
  }

  void scrollUp() {
    //topacity++;
    //if (topacity>255) topacity = 255;
    //fill(t, topacity);



    // move up and then show the next lines that are hidden (scrolling)
    int maxPortHeight = linesPerScreen * 25 + 10;
    for (int y_ = yStart; y_ < maxPortHeight; y_+= 25) {
      location.y = y_;
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
    for (int i = 0; i < screen.length; i++) {
      screen[i].scrollUp();
      screen[i].display();
      //text(screen[i], location.x, location.y);
      //x += textWidth(screen[y]);
      //x++;
      //    location.y+= 25; //***** issue here, no? just want the text scrolling up, once it's appeared
    }
    //if (frameCount %28 == 0) {
    //  y--;
    //}
  }
}
