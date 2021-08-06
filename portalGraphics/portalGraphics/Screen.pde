class Screen { //<>// //<>// //<>// //<>// //<>// //<>//

  PFont f;
  PVector screen_location, text_location, velocity, acceleration;
  // color t;

  String[] line;
  int topacity;
  int start;
  int yStart;

  Screen(PVector l, int s) {
    start = s; //location in text file
    // print("start of this screen is: ");
    // println(start);
    acceleration = new PVector(0, -.1);
    velocity = new PVector(0, 0);
    screen_location = l.copy();
    // print("screen inside constructor is: ");
    // println(screen_location);
    //text_location = l.copy();
    //text_location.add(10, 10); // in and down a smidge
    text_location = new PVector(screen_location.x, screen_location.y);  // was (10, 30) for testing
    // print("text loc inside constructor is: ");
    // println(text_location);
    // not sure what to do with this line here with reference to line vvvvv
    //yStart = int(screen_location.y) + 200; 
    topacity = 80;
    //t = color(75, 255, 85, topacity);
    //f = createFont("Arial", 12);
    //textFont(f, 24);
    //textAlign(LEFT);
    //fill(t);


    line = new String[10];
    //line = 0;
    //initalize();
  }

  int initalize(int l, String[] packetText) { // load the array (for screen) up with text
    //    fill(t, topacity);
    // show first 10 lines
    // take the first 10 lines and load them in to screen array
    // println("loading up more text");
    int limit = start + l; // current lineNum + 9
    // print("limit inside initalize is: ");
    // println(limit);
    int l_num = 0; // increment marker for which line on this screen we are on
    //    pushMatrix();
    //    translate(screen_location.x, (screen_location.y)); // added +250 to the y
    for (int i = start; i < limit; i++) { // i used for inputText line number
      String temp = packetText[i]; //
      // load the packet info into the array 
      line[l_num] = temp; //new Line(i, location); //location for inputText gets passed in
      //println(line[l_num]);
      // make them visual vvvv
      //print("text_location is: "); println(text_location);
      //      text(line[l_num], 10, 30 ); //text_location.x, text_location.y
      //      text_location.y += 25;

      //screen[l_num].display();
      l_num++;
      //print("s is: ");
      //println(s);
    }
    //    popMatrix();
    //displayScreen();

    return limit;
  }

  void update() {

    topacity+=1;
    if (topacity > 255) topacity = 255;
    //println(topacity);
    velocity.add(acceleration);
    // println(velocity);
    velocity.limit(10);
    // update scroll variables
    // topacity = top;
  }

  void run() {
    update();
    scrollUp();
    // for (int i = 0; i < linesPerScreen; i++) {
    //screen[i].scrollUp();
    displayScreen();
    // }
  }

  void scrollUp() {
    //topacity++;
    //if (topacity>255) topacity = 255;
    //fill(t, topacity);



    // move up and then show the next lines that are hidden (scrolling)
    //int maxPortHeight = linesPerScreen * 25 + 10;
    //for (int y_ = yStart; y_ < height; y_+= 25) {
    //println(velocity);
    screen_location.add(velocity);
    //screen_location.y-=35; //speed of scroll
    //print("screen_location is: "); 
    //println(screen_location.y);
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
    //}
    // yStart--;
  }

  void displayScreen() {
    //    println(topacity); 

    //x = 0;
    //pushMatrix();
    ////scale(.25);
    //translate(screen_location.x, screen_location.y);
    //scale(.5);
    //    print("screen location in display screen is: "); 
    //    println(screen_location);
    //println();
    text_location = new PVector( (-20), 30); // need to reset it // but with the matrix translation, it should be fine
    //    print("text loc inside displayScreen is: ");
    //    println(text_location);
    if (frameCount % 10 == 0) {
      text_location.x+= 50; //(screen_location.x + 50);
    } else {
      text_location.x = -20; //screen_location.x + 10;
    }
    // t = color(75, 255, 85, 100);
    fill(0, 255, 0, topacity);

    for (int i = 0; i < line.length-1; i++) { //last spot in array is empty due to initalize()'s for-loop structure
      //screen[i].scrollUp();
      //screen[i].display();
      //  print("text_location y is: "); 
      // println(text_location.y);
      pushMatrix();
      //scale(.25);
      translate(screen_location.x, screen_location.y);
      scale(.5);
      //fill(75, 255, 85, 255);
      text(line[i], text_location.x, text_location.y);
      popMatrix();
      if ( i != line.length-2) {
        text_location.y+= 25; //***** issue here, no? just want the text scrolling up, once it's appeared
      }
    }
    //if (frameCount %28 == 0) {
    //  y--;
    //}
    if (frameCount % 26 == 0) {
      pushMatrix();
      //scale(.25);
      translate(screen_location.x, screen_location.y);
      scale(.5);
      fill(0, 130);
      rect(80, 30, 600, 200);
      popMatrix();
    }
    // popMatrix();
  } // displayScreen
} //class
