//PFont f; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
//float x, y;

import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import netP5.*;
import codeanticode.syphon.*; //

PGraphics canvas; // need this for projection mapping thru syphon via madmapper
SyphonServer server;

OscP5 whereimlistening; // equivalent to [udpreceive] in max, e.g. it's listening
NetAddress whereimsending; // equivalent to [udpsend] in max - it's sending
String messageselector;

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
int yScreen;

ArrayList<Screen> textBuffers;
int numScreens;

//color t = color(75, 255, 85);


void setup() {
  size(800, 800);
   server = new SyphonServer(this, "Processing Syphon Text");
   whereimlistening = new OscP5(this, 12001);
  //frameRate(10);
  background(0);
  //f = createFont("Arial", 16);
  //textFont(f, 24);
  //textAlign(LEFT);
  //fill(t);
  inputText = loadStrings("packets.txt");
  //x = 20;
  //y = 20;
  background(0);
  howManyLines = inputText.length;
  //println(howManyLines);
  numScreens = ceil(howManyLines/10);
  //println(howManyLines);
  textBuffers = new ArrayList<Screen>();
  currentLineNum = 0;
  yScreen = 420; // will need to be modified ****
//  PVector offScreen = new PVector(20, yScreen); //location of portal ****
  linesPerScreen = 9;
  int nextStart = 0;
  //for (int i = 0; i < numScreens; i++) { //<>//
  //  Screen s = new Screen(offScreen, nextStart); //this is going to need the portal location + some to y //<>//
  //  nextStart = s.initalize();  //<>//
  //  //println(currentLineNum);
  //  //currentLineNum += 9; // *** think about this
  //  offScreen.y = offScreen.y + (10 * 22); //each LINE plus some space
  //  textBuffers.add(s);

    //textBuffers[i] = s;
//  }
  //textBuffers[0].initalize(); // very important



  //println(screenLine);
  //cln = initalize(currentLineNum);
  //print("cln is: ");
  //println(cln);
}


void draw() {
  
  //if(frameCount %2 == 0) background(0);
  background(0);
  //textBuffers[0].scrollUp();
  //textBuffers[0].run(); // needs opacity to feed in
  for(Screen s : textBuffers){
    s.run();
  }
  
  for(int i = textBuffers.size()-1; i >=0; i--){
    Screen s = textBuffers.get(i);
    if((s.screen_location.y + (10 * 22)) < 0) textBuffers.remove(i);
  }

  //text("hello", 20, 20);

  //displayScreen();

  // every X seconds: 
  //scrollUp();
 server.sendScreen();
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
  //println(cln);
  //cln = cln+10;
  //print("updated cln: ");
  //println(cln);
  //initalize(cln);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  for (int i = 0; i <numScreens; i++) {
      Screen s = new Screen(loc, nextStart);
       nextStart = s.initalize(linesPerScreen, inputText);
      loc.y = loc.y + (10 * 10.9); // each LINE plus some space; was * 22; need to tweak if scale changes
      textBuffers.add(s);
  }
    screenLine = 0;

}
