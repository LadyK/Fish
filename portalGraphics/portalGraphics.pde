import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import netP5.*;
int checker = 0;
int loopChecker = 0;
//OscP5 whereimlistening; // equivalent to [udpreceive] in max, e.g. it's listening
NetAddress whereimsending; // equivalent to [udpsend] in max - it's sending
//String messageselector;

OscP5 whereimlistening;

/* a NetAddress contains the ip address and port number of a remote location in the network. */

String messageselector;

Integer[] screenLoc = {0, 0};
//ArrayList <PVector> locations;
//PVector[] locations;


Cloud fish; //<>// //<>//
ArrayList<Cloud> herd; // a bunch of shape groups to make one cloud
//Cloud[] herd;

ArrayList <BasicShapeElement> demos;
//BasicShapeElement[] demos;

boolean trigger;
//int lastRecMouseX = 0;
//int lastRecMouseY = 0;
//int lastMouseX, lastMouseY;
int distDiff= 10; // how much of a difference in mouse location needed
long movedStamp;
boolean portalTrig;
//Portal entry;
ArrayList<Portal> entry;
long portBirth;
PVector lastLoc, currentLoc;
boolean newSpot = false;
boolean maturePort = false;
boolean shrinking = false;
boolean firstLoc = true;
//int portalPoints = 18;
//int locations_indice = 0;

void setup() {
  //size(displayWidth, displayHeight); 
  size(800, 800);
  //background(0);

  trigger = false;
  herd = new ArrayList<Cloud>(1000); // <--- hmm
  //herd = new Array[2000];
  //PVector[] locations = new PVector[2000];
 // locations = new ArrayList<PVector>(1000);
  //BasicShapeElement[] demo = new BasicShapeElement[2000];
  demos = new ArrayList<BasicShapeElement>(1000);
  portalTrig = false;
  entry = new ArrayList<Portal>(1000);
  /*
  Cloud[] herd = new Cloud[2000];
   //clouds = new ArrayList<Cloud>();
   
   for (int i = 0; i < 10; i++) {  // loop through the array
   //shapes[i] = new Shape();      // make a new object at each indice
   //cloudArray.add(new Shape(width/2, height/2));
   clouds.add(new Cloud());
   }
   */
  // do the OSC setup stuff
  //whereimlistening = new OscP5(this, 12000);
  /* create a new NetAddress. a NetAddress is used when sending osc messages
   * with the oscP5.send method.
   */
  whereimsending = new NetAddress("127.0.0.1", 12000); // hostname, port
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  /* start oscP5, listening for incoming messages at port 12000 */
  whereimlistening = new OscP5(this, 12000);

  //screenLoc[0] = 0;
  //screenLoc[1] = 0;

  PVector tester = new PVector(mouseX, mouseY);
  newSpot(tester);
}

void draw() {
  background(0);

  /* // ************* old code (before refactor)
   
   // randomly kill off a few _shapes_ from within the cloud herd
   if (frameCount % 8 == 0) {
   for (int i = 5; i < 0; i--) {
   int rando = floor(random(0, herd.size()-1));
   Cloud temp = herd.get(rando);
   temp.plague(); 
   //float whichOne = abs(random(1, herd.size()));
   // herd.remove(whichOne); 
   */

  // run the demos if we have any:
  if (demos.size() > 0) {
    //loopChecker++;
    // print("loopChecker: ");
    // println(loopChecker);
    print("Demos is: ");
    println(demos.size()-1);
    for (int i= demos.size()-1; i >= 0; i--) {
      BasicShapeElement shape = demos.get(i);
      //expandShrink();
      shape.display();
      //shape.shrink();
      boolean dead = shape.update();
      if (dead) {   // **** here with refactoring code with arrays
        demos.remove(i);  // if we remove one, breaks out of loop and stops
        //locations.remove(i);
        println("removed one");  // displaying rest, until loop is restored
      } else {  continue;  // continue keeps the for-loop running
        //print("middle point is:  "); println(shape.middle);
        //float d = dist(shape.centerX, mouseX, shape.centerY, mouseY);
        //if(locations[i] == mouseLoc + 10/-10){ <<-------
          
        
        
        /*
        PVector middle = shape.centerLoc();  // <-- not sure if this is right
        PVector m = new PVector(mouseX, mouseY);
        PVector difference = PVector.sub(m, middle);
        float d = difference.mag();
        //print("distance is:   "); println(d);
        //print("shape diameter is:  "); println(shape.r * 2);
        
        if (d < (shape.r * 2)) {  // <-- logic here is off
          
          shape.expand();
          println("expand");
        }
        }
        */
      }
    }
  }
} // draw loop



/* this isn't working correct
 desired: when close: shape expands
 when far: shape shrinks  */
void expandShrink() {
  /* all kinds of weird action happening here. fun. but not what I'm after
   for(BasicShapeElement shapie: demos){
   if (shapie.centerX > (mouseX + distDiff) || shapie.centerX < (mouseX - distDiff) ||
   shapie.centerY  > (mouseY + distDiff)  || shapie.centerY  < (mouseX - distDiff) ) {
   // shapie.expand();
   } // if we are close
   else {
   shapie.shrink();
   }
   }
   */


  for (BasicShapeElement shapie : demos) {
    float d = dist(shapie.centerX, mouseX, shapie.centerY, mouseY);
    if (d < shapie.r) {
      shapie.expand();
    } else {
      // shapie.shrink();
    }
  }
}


void triggerPortal() {
  //print("num of portals: ");
  //println(entry.size());
  // if we dont have portals, create some:
  if (entry.size() < 1 && portBirth <= 0) {
    for (int i = 0; i < 5; i++) {
      int randX = 0; //int(random(-5, 5));
      int randY = 0; //int(random(-5, 5));
      Portal temp = new Portal(screenLoc[0] + randX, screenLoc[1]  + randY, 10, 15);
      entry.add(temp);
      //  portalTrig = false;
    }
    portBirth = millis();
  }
}

void mousePressed() {
}

void mouseMoved() {
  PVector tester = new PVector(mouseX, mouseY);
  newSpot(tester);   //send location to be checked. then made a new one elsewhere
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  // println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  // println(" addrpattern: "+theOscMessage.addrPattern());
  //theOscMessage.print();

  // splice theOscMessage.addrPattern()
  //areWeRunning = true;
  String [] newLocations = splitTokens(theOscMessage.addrPattern());
  for (int j =0; j < newLocations.length; j ++) {
    screenLoc[j] = int(newLocations[j]);
  }
  print(screenLoc[0]); 
  print(", ");
  println(screenLoc[1]);
  //println(theOscMessage.addrPattern().length());
  int tempX = int(screenLoc[0]);
  int tempY = int(screenLoc[1]);
  PVector newLoc = new PVector(tempX, tempY);
  newSpot(newLoc);
}

void newSpot(PVector newbie) {
  //print(locations.size()-1);
  //println("   is how many locations we have");
  BasicShapeElement tester = new BasicShapeElement(int(newbie.x), int(newbie.y), 5, 25); 
  demos.add(0, tester);
  //locations.add(newbie);
  println("new spot added");
}
