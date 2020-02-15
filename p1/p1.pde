<<<<<<< Updated upstream
import processing.pdf.*;
import java.util.Calendar;

=======
import processing.pdf.*; //<>// //<>//
import java.util.Calendar;


>>>>>>> Stashed changes
boolean savePDF = false;

PImage orig;
PImage mask;
<<<<<<< Updated upstream

import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
=======
int radius = 150; // radius of shapes

import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
>>>>>>> Stashed changes
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
ArrayList <PVector> all_locations;
//PVector[] locations;


<<<<<<< Updated upstream
Cloud fish; //<>//
=======
Cloud fish;
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
//ArrayList<Portal> entry;
=======
ArrayList<Portal> entry;
>>>>>>> Stashed changes
long portBirth;
PVector lastLoc, currentLoc;
boolean newSpot = false;
boolean maturePort = false;
boolean shrinking = false;
boolean firstLoc = true;
//int portalPoints = 18;
//int locations_indice = 0;
PVector newLoc, currentLocation;
int numColors = 300;
float c_rand;


void setup() {

  size(672, 896);
<<<<<<< Updated upstream
  orig = loadImage("L_300dpi_smallerStill.jpg");
  mask = loadImage("maskBlack_inv.png");
=======
  frameRate(3);
  orig = loadImage("backLeftPresent.png");
  mask = loadImage("backLeftAbsent.png");
>>>>>>> Stashed changes
  image(orig, 0, 0);
  //mask.mask(orig);

  trigger = false;
<<<<<<< Updated upstream
=======
  //  all_locations = new ArrayList<PVector>(1000);
>>>>>>> Stashed changes
  all_locations = new ArrayList<PVector>(1000);
  herd = new ArrayList<Cloud>(1000); // <--- hmm
  demos = new ArrayList<BasicShapeElement>(1000);
  portalTrig = false;
  //entry = new ArrayList<Portal>(1000);
  currentLocation = new PVector(-100, -100);
  PVector tester = new PVector(mouseX, mouseY);
  newSpot(tester);
}


void draw() {
<<<<<<< Updated upstream
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  //image(mask, 0, 0);
=======
  background(0);
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  image(mask, 0, 0);
>>>>>>> Stashed changes
  image(orig, 0, 0);

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
      PVector loc = all_locations.get(i);
      BasicShapeElement shape = demos.get(i);
      shape.featureShifter();
      //expandShrink();
      shape.display();
      //shape.shrink();
      boolean dead = shape.update();
      if (dead) {   // **** here with refactoring code with arrays
        demos.remove(i);  // if we remove one, breaks out of loop and stops
        all_locations.remove(i);
        println("removed one");  // displaying rest, until loop is restored
      } else {  
        float d = dist(loc.x, currentLocation.x, loc.y, currentLocation.y);
        if (d < shape.r ) {
<<<<<<< Updated upstream
          shape.expand();
=======
          //shape.expand();
>>>>>>> Stashed changes
          //println(" close so grow");
        }
      }
    }
  }
  image(mask, 0, 0); //<---
} // draw loop

<<<<<<< Updated upstream


void mousePressed() {

  // PVector tester = new PVector(mouseX, mouseY);
  //newSpot(tester);   //send location to be checked. then made a new one elsewhere
}

void mouseMoved() {
=======
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
  /*
  if ( (mouseX < abs(pmouseX-radius)) || (mouseX > abs(pmouseX+radius))
   || (mouseY < abs(pmouseY-radius)) ||  (mouseY > abs(pmouseY+radius)) ) {
   
   float d = dist(pmouseX, pmouseY, mouseX, mouseY);
   print("distance is:  ");
   println(abs(d));
   if ( abs(d) > radius) {
   */
>>>>>>> Stashed changes
  PVector tester = new PVector(mouseX, mouseY);
  currentLocation = newSpot(tester);   //send location to be checked. then made a new one elsewhere
}


<<<<<<< Updated upstream
PVector newSpot(PVector newbie) {
  //print(locations.size()-1);
  //println("   is how many locations we have");
  BasicShapeElement tester = new BasicShapeElement(int(newbie.x), int(newbie.y), 7, 35); 
=======


PVector newSpot(PVector newbie) {
  //print(locations.size()-1);
  //println("   is how many locations we have");
  BasicShapeElement tester = new BasicShapeElement(int(newbie.x), int(newbie.y), 7, radius); 
>>>>>>> Stashed changes
  demos.add(0, tester);
  all_locations.add(newbie);
  println("new spot added");
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
