import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import netP5.*;
import java.util.Map;
import codeanticode.syphon.*;

PGraphics canvas; // need this for projection mapping thru syphon via madmapper
SyphonServer server;

int checker = 0;
int loopChecker = 0;
//OscP5 whereimlistening; // equivalent to [udpreceive] in max, e.g. it's listening
NetAddress whereimsending; // equivalent to [udpsend] in max - it's sending
//String messageselector;

OscP5 whereimlistening;



/* a NetAddress contains the ip address and port number of a remote location in the network. */

// need graphics to be more responsive to max values. spread north + south?

String messageselector;

Integer[] screenLoc = {0, 0};
//ArrayList <PVector> all_locations;
//PVector[] locations;


ArrayList <Cloud> demos;
//BasicShapeElement[] demos;
ArrayList <Portal> portals;

ArrayList<Shape> triggers;

//HashMap<String, Cloud> storm = new HashMap<String, Cloud>();

boolean trigger;
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
PVector newLoc, currentLocation;
int numColors = 600;    
float c_rand;
PVector previousMouse; 
int ius = 30;

float  rd, gn, blu;
color  kuler, paint;
long intervalPort;

void setup() {
  size(640, 480, P3D);  // need to send less to max to send out? 800?
  //canvas = createGraphics(1280, 1024, P3D); // out to syphon
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  //size(displayWidth, 300 ); 
  //  size(800, 800, P3D);
  //frameRate(20);
  //background(0);
  colorMode(RGB, 1.0, 1.0, 1.0, 255);

  //colorMode(HSB, 255);

  trigger = false;
  // herd = new ArrayList<Cloud>(1000); // <--- hmm
  // herd = new ArrayList[1000];
  //all_locations = new PVector[1000];
  // all_locations = new ArrayList<PVector>(1000);
  //BasicShapeElement[] demo = new BasicShapeElement[2000];
  portals = new ArrayList<Portal>();
  demos = new ArrayList<Cloud>(50);
  triggers = new ArrayList<Shape>(10);
  portalTrig = false;

  rd = 0;
  gn = random(1);  // 128, 255
  blu = random(1); // 0, 192
  kuler = color(rd, gn, blu);

  //entry = new ArrayList<Portal>(1000);
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
  /* create a new NetAddress. a NetAddress is used when sending osc messages
   * with the oscP5.send method.
   */
  whereimsending = new NetAddress("127.0.0.1", 12001); // hostname, port
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  /* start oscP5, listening for incoming messages at port 12000 */
  whereimlistening = new OscP5(this, 12000);

  //screenLoc[0] = 0;
  //screenLoc[1] = 0;
  currentLocation = new PVector(-400, -400);
  //  PVector tester = new PVector(mouseX, mouseY);
  newSpot(currentLocation);
  //  previousMouse = new PVector(-100, -200);
}

void draw() {
  //canvas.beginDraw();
  //canvas.background(0);
  background(0);
  /* not so noticible now bc more fog-like; 
   // ************* old code (before refactor)
   
   // randomly kill off a few _shapes_ from within the cloud herd
   if (frameCount % 8 == 0) {
   for (int i = 5; i < 0; i--) {
   int rando = floor(random(0, demos.size()-1));
   Cloud temp = demos.get(rando);
   temp.plague(); 
   //float whichOne = abs(random(1, herd.size()));
   // herd.remove(whichOne); 
   }
   }
   */
  siblingsCheck();

  // run the demos if we have any:
  if (demos.size() > 0) {
    colorChange(); // not sure why opacity is so bright when controlling color here, versus within the class
    // print("Demos is: ");
    // println(demos.size()-1);
    for (int i= demos.size()-1; i >= 0; i--) {
      // PVector loc = all_locations.get(i);
      Cloud c = demos.get(i);
      if (c.shapes.size() <= 0) { // if the size of the shapes array (ie, cloud elements) in the cloud object is (nearly) empty
        demos.remove(i);
        //   println("removed one");
      } else {
        // spreadNorth();
        //c.randY = c.randY - 10;
        c.run();
        if (c.stillThere >= intervalPort) {
        }
      }
      //print("middle point is:  "); println(shape.middle);
      //float d = dist(shape.centerX, mouseX, shape.centerY, mouseY);
      //if(locations[i] == mouseLoc + 10/-10){ <<-------
      /*
        float d = dist(loc.x, currentLocation.x, loc.y, currentLocation.y);
       if (d < shape.r ) {
       //shape.expand();
       
       //println(" close so grow");
       }
       
       */
      //expandShrink();
      /*
        //if shape location is similar to newest/mouse/current
       if(newLoc.x < shape.centerX + 5 || newLoc.x > shape.centerY - 5 ){
       println("EXPAND");
       }
       */

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
  // run triggers/rings:
  //print("triggers is: "); println(triggers.size());
  for (int i = triggers.size()-1; i >= 0; i--) {
    Shape s = triggers.get(i);
    if (s.o <= 1) {
      triggers.remove(i);
      // println("Trigger removed");
    } else {
      s.update_();
    }
  }
  // run portals:
  /*
  for (int i = portals.size()-1; i >=0; i--) {
   Portal p_ = portals.get(i);
   // where are we getting rid of old/bad portals?? <-- figure this out
   p_.featureShifter();
   p_.display();
   }
   */
  server.sendScreen();
} // draw loop

void siblingsCheck() {
  for (int i= demos.size()-1; i >= 0; i--) {  // since new ones are added to the end, start there
    // PVector loc = all_locations.get(i);
    Cloud c = demos.get(i);
    if (c.siblings == c.howMany) {
      continue;
    } else {
      c.randX = int(random(-c.randoX, c.randoX)) + int(c.loc.x);
      c.randY = int(random(-c.randoY * 4, (c.randoY * .2))) + int(c.loc.y); // increase this along the y-axis via for-loop ?
      BasicShapeElement temp = new BasicShapeElement(c.randX, c.randY, 7, c.radius, c.howMany, c.alpha, c.rando); 
      c.shapes.add(0, temp);
      c.siblings++;
    }
  }
}

  void colorChange() {

    float curTime = millis()/1000.0;
    // c_rand = random(0.5, 0.6);
    // curTime = c_rand * curTime;

    //println(curTime);
    //if (frameCount % 10 == 0) {
    for (int i=0; i< numColors; i++) {

      rd = sin(curTime * 0.8f + i * 0.0011f) + 0.5f; //R  + 0.8f
      gn = sin(curTime * 0.7f + i * 0.0013f) + 0.5f; //G * 0.5f + 0.5f   + 0.5f
      blu = sin(curTime * 0.3f + i * 0.0017f) + 0.5f; 
      rd = abs(rd);
      gn = abs(gn);
      blu = abs(blu);
      kuler = color(rd, gn, blu);
    }

    paint = kuler;
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
    /*
// if (frameCount % 2 == 0) {
     float randX = random((-radius), (radius));
     float randY = random((-radius), (radius));
     PVector tester = new PVector(mouseX + randX, mouseY + randY);
     currentLocation = newSpot(tester);   //send location to be checked. then made a new one elsewhere
     // }
     */

    //PVector newLoc = new PVector(mouseX, mouseY);
    //if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
    //  //newLoc.x = map(newLoc.x, 0, 640, 0, width);
    //  //newLoc.y = map(newLoc.y, 0, 480, 0, height);
    //  flash(newLoc); // ring triggers
    //  newSpot(newLoc); // new cloud
    //  //println();
    //  //println("new cloud and ring");
    //  //println("Made new cloud");
    //} else if (checkLocations(newLoc) == true) {
    //  // println("none made");
    //}
  }

  void keyPressed() {

    print("Demos is: ");
    println(demos.size());
    print("Triggers is: ");
    println(triggers.size());
    print("Portals is: ");
    println(portals.size());

    if (key == 32) {
      noLoop();
    }
    if (key == 'z') {
      loop();
    }
  }

  void mouseMoved() {
    //PVector m = new PVector(mouseX, mouseY);
    //float d = m.dist(previousMouse);
    //print(" distance between is:  ");
    //println(d);
    //if (d < 3 && d >= 0.2) {
    //  // if( d > 0.0){
    //  float randX = random((-radius), (radius));
    //  float randY = random((-radius), (radius));
    //  PVector tester = new PVector(mouseX + randX, mouseY + randY);
    //  currentLocation = newSpot(tester);   //send location to be checked. then made a new one elsewhere
    //} else if (d < .2) {
    //  //fill(255, 0, 0);
    //  //ellipse(mouseX, mouseY, 20, 20);
    //  // launch portal if a long time been here
    //} 
    //previousMouse = m;
    //  newLoc = new PVector(mouseX, mouseY);
    //  if (!checkLocations(newLoc)) { // <---- same spot?
    //    newSpot(newLoc);
    //  }


    PVector newLoc = new PVector(mouseX, mouseY);
    if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
      //newLoc.x = map(newLoc.x, 0, 640, 0, width);
      //newLoc.y = map(newLoc.y, 0, 480, 0, height);
      // newLoc.x = map(newLoc.x, 0, width, 0, 450);
      newLoc.y = map(newLoc.y, 0, 480, 0, height);

      flash(newLoc); // ring triggers
      newSpot(newLoc); // new cloud
      //println();
      //println("new cloud and ring");
      //println("Made new cloud");
    } else if (checkLocations(newLoc) == true) {
      // println("none made");
    }
  }


  boolean checkLocations(PVector nLoc) {
    // print("demo size: "); 
    //println(demos.size());
    boolean tooClose = false;
    for (int i= demos.size()-1; i >= 0; i--) {
      // PVector loc = all_locations.get(i);
      Cloud c = demos.get(i);
      //Shape s = triggers.get(i);
      if (c.tooclose(nLoc) == true ) {
        tooClose = true;
        break;
      } else {
        tooClose = false;
      }
    }
    return tooClose;
  }

  boolean checkTriggers(PVector nLoc) {
    boolean same = false;
    for (int i = triggers.size()-1; i >=0; i--) {
      Shape s = triggers.get(i);
      if (s.tooclose(nLoc) == true) {
        same = true;
        break;
      } else {
        same = false;
      }
    }
    return same;
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
    /*
  print(screenLoc[0]); 
     print(", ");
     println(screenLoc[1]);
     */
    //println(theOscMessage.addrPattern().length());
    int tempX = int(screenLoc[0]);
    int tempY = int(screenLoc[1]);

    // float randX = random((-radius), (radius));
    // float randY = random((-radius), (radius));
    //   PVector tester = new PVector(mouseX + randX, mouseY + randY);
    //newLoc = new PVector(tempX + randX, tempY + randY);
    newLoc = new PVector(tempX, tempY);
    //println(newLoc);
    if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
      //newLoc.x = map(newLoc.x, 0, 640, 0, width);
      newLoc.x = map(newLoc.x, 0, width, 0, 450); // strained because of masking in madmapper
      newLoc.y = map(newLoc.y, 0, 480, 0, height);
      flash(newLoc); // ring triggers
      newSpot(newLoc); // new cloud
      //println("new cloud and ring");

      //println("Made new cloud");
    } else if (checkLocations(newLoc) == true) {
      //println("none made");
    }
  }



  void flash(PVector l_) {
    Shape spot = new Shape(int(l_.x), int(l_.y), 7, ius);
    triggers.add(spot);
    //println("New Trigger added");
  }


  PVector newSpot(PVector newbie) {
    //print(locations.size()-1);
    //println("   is how many locations we have");
    //for (int i = 0; i < 4; i++) {
    //float randX = random((-radius), (radius));
    //float randY = random((-radius), (radius));
    //BasicShapeElement tester = new BasicShapeElement(int(newbie.x) + randX, int(newbie.y) + randY, 7, radius); 

    // must map values from 640, 480 interface to a 1280, 1024 sketch

    //print("parameters are: "); println(newbie.y);
    Cloud tester = new Cloud(newbie, 50, 15, 30, 10);  // loc, prox, radius, #, o
    //println(tester.birth);
    demos.add(tester); // took out (0, tester)
    //}
    //all_locations.add(newbie);
    //println("new spot added");
    return newbie;
  }
