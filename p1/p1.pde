//<>// //<>// //<>// //<>// //<>// //<>//

import processing.pdf.*;
import java.util.Calendar;



boolean savePDF = false;

PImage orig;
PImage mask;


int radius = 60; // radius of shapes

import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

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
//ArrayList <PVector> all_locations;
//PVector[] locations;



Cloud fish;

ArrayList<Cloud> demos; // a bunch of shape groups to make one cloud
//Cloud[] herd;

ArrayList <Portal> portals;
//BasicShapeElement[] demos;

ArrayList<Shape> triggers;

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
PVector newLoc, currentLocation;
int numColors = 500;
float c_rand;
PVector previousMouse; 


void setup() {

  size(960, 1216);
  colorMode(RGB, 1.0, 1.0, 1.0, 255);
  frameRate(3);
  orig = loadImage("maskWrinkle4.png");
  mask = loadImage("4wrinkle.png"); // really the background

  image(orig, 0, 0);
  //mask.mask(orig);

  trigger = false;



  //all_locations = new ArrayList<PVector>(1000);
  //herd = new ArrayList<Cloud>(1000); // <--- hmm
  //demos = new ArrayList<BasicShapeElement>(1000);

  portals = new ArrayList<Portal>();
  demos = new ArrayList<Cloud>(50);
  triggers = new ArrayList<Shape>(10);
  portalTrig = false;

  //entry = new ArrayList<Portal>(1000);
  currentLocation = new PVector(-400, -400);
  //PVector tester = new PVector(mouseX, mouseY);
  newSpot(currentLocation);
}


void draw() {

  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  //image(mask, 0, 0);

  image(mask, 0, 0); // <- what gets covered

  //mask.loadPixels();

  //for(int x = 0; x < mask.width; x++){
  //  for(int y = 0; y < mask.height; y++){

  // if the pixel is black + the mouse is over it:
  // run the animation
  // run the demos if we have any:
  if (demos.size() > 0) {
    //loopChecker++;
    // print("loopChecker: ");
    // println(loopChecker);
    print("Demos is: ");
    println(demos.size()-1);
    for (int i= demos.size()-1; i >= 0; i--) {
      Cloud c = demos.get(i);
      if (c.shapes.size() <= 0) {
        demos.remove(i);
      } else {
        c.run();
      }
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
    p_.featureShifter();
    p_.display();
  }
*/
  image(orig, 0, 0); //<--- // this is really the mask
} // draw loop



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
  // PVector tester = new PVector(mouseX, mouseY);
   //newSpot(tester);   //send location to be checked. then made a new one elsewhere
   
   float d = dist( mouseX, mouseY, pmouseX, pmouseY);
   print("mouse x is: ");
   println(mouseX);
   print("Prevous mouse x is: ");
   println(pmouseX);
   print("distance is:  ");
   println(abs(d));
   if ( abs(d) > radius) {
   println("We are far enough");
   } */
}

void mouseMoved() {
  PVector m = new PVector(mouseX, mouseY);
  //float d = m.dist(previousMouse);
  //print(" distance between is:  ");
  //println(d);
  //if (d < 3 && d >= 0.2) {
    // if( d > 0.0){
    //  float randX = random((-radius), (radius));
    //  float randY = random((-radius), (radius));
    //  PVector tester = new PVector(mouseX + randX, mouseY + randY);
    //  currentLocation = newSpot(tester);   //send location to be checked. then made a new one elsewhere
 // } else if (d < .2) {
    //  //fill(255, 0, 0);
    //  //ellipse(mouseX, mouseY, 20, 20);
    //  // launch portal if a long time been here
    //} 
    //previousMouse = m;
    //  newLoc = new PVector(mouseX, mouseY);
    newLoc = new PVector(mouseX, mouseY);
    if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
      //newLoc.x = map(newLoc.x, 0, width, 0, height);
      //newLoc.y = map(newLoc.y, 0, width, 0, height);
      flash(newLoc);
      newSpot(newLoc);
      println("new cloud and ring");
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

void flash(PVector l_) {
  Shape spot = new Shape(int(l_.x), int(l_.y), 7, radius);
  triggers.add(spot);
  //println("New Trigger added");
}

PVector newSpot(PVector newbie) {
  //print(locations.size()-1);
  //println("   is how many locations we have");
  Cloud tester = new Cloud(newbie);
  //println(tester.birth);
  demos.add(tester); // took out (0, tester)
  return newbie;
}


void keyReleased() {  
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  //if (key=='p' || key=='P') savePDF = true;
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
