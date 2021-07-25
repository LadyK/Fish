//PFont f; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
//float x, y;
int index = 0;

String[] inputText;
//String[] allTheText;
//String[] currentLine;
int currentLineNum;
int howManyLines;
int linesPerScreen;
//String[] screen = new String[10];
int screenLine = 0;
//int yStart = 0;
//int line = 0;
int cln;

Screen[] textBuffers;
int numScreens;

//color t = color(75, 255, 85);


void setup() {
  size(800, 800);
  background(0);
  //f = createFont("Arial", 16);
  //textFont(f, 24);
  //textAlign(LEFT);
  //fill(t);
  inputText = loadStrings("packets2_test.txt");
  //x = 20;
  //y = 20;
  background(0);
  howManyLines = inputText.length;
  //println(howManyLines);
  numScreens = ceil(howManyLines/10);
  textBuffers = new Screen[numScreens];
  currentLineNum = 0;
  PVector offScreen = new PVector(20, 420); //location of portal
  linesPerScreen = 9;
  for (int i = 0; i < numScreens; i++) {
    Screen s = new Screen(offScreen, currentLineNum); //this is going to need the portal location + some to y
    currentLineNum += 10;
    
    
    textBuffers[i] = s;
  }
  textBuffers[0].initalize();
  
  

  //println(screenLine);
  //cln = initalize(currentLineNum);
  //print("cln is: ");
  //println(cln);
}


void draw() {
   background(0);
   textBuffers[0].run(); // needs opacity to feed in
   //textBuffers[0].scrollUp();
 
  //text("hello", 20, 20);

  //displayScreen();

  // every X seconds: 
  //scrollUp();
}

//int initalize(int s) {
//  //currentLineNum = s;
//  print("s is: ");
//  println(s);
//  // show first 10 lines
//  // take the first 10 lines and load them in to screen array
//  println("loading up more text");
//  int limit = s + screen.length;
//  int l_num = 0;
//  for (int i = s; i < limit; i++) {
//    //String temp = 
//    // println(i);

//    String temp = inputText[i];
//    screen[l_num] = temp;
//    // println(screen[i]);
//    l_num++;
//    //s++;
//    print("s is: ");
//    println(s);
//  }
//  displayScreen();
//  return s;
//}

//void scrollUp() {
//  //int line = 0;
//  //int j = 0;
//  //int line = 0;

//  // move up and then show the next lines that are hidden (scrolling)
//  for (int y_ = yStart; y_ <= screen.length; y_+= 25) {
//    text(screen[line], 0, y_);
//    if (line < linesPerScreen) {
//      line++;
//      //print("line number for scroll: ");
//      //println(line);
//    } else if (line == linesPerScreen) {
//     // println("LINES MORE THAN LINESPERSCREEN");
//      //println("getting new line");
//      //print("currentLineNum is: ");
//      //println(currentLineNum);
//       cln = cln+10;
//      initalize(cln);
//      line = 0;
//    }
//  }
//  yStart--;
//}



void pullNewFile() {
  // every x minutes, load each line of the file into an array
}

void mousePressed() {
  //displayScreen();
  println(cln);
  cln = cln+10;
  print("updated cln: ");
  println(cln);
  //initalize(cln);
}
