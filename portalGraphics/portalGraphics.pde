import oscP5.*; //<>// //<>// //<>//
import netP5.*;

//OscP5 whereimlistening; // equivalent to [udpreceive] in max, e.g. it's listening
NetAddress whereimsending; // equivalent to [udpsend] in max - it's sending
//String messageselector;

OscP5 whereimlistening;

/* a NetAddress contains the ip address and port number of a remote location in the network. */

String messageselector;

Integer[] screenLoc = {0, 0};
ArrayList <PVector> locations;

Cloud fish; //<>// //<>// //<>// //<>// //<>//
ArrayList<Cloud> herd; // a bunch of shape groups to make one cloud

ArrayList <BasicShapeElement> demos;

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
int locations_indice = 0;

void setup() {
  //size(displayWidth, displayHeight); 
  size(800, 800);
  //background(0);

  trigger = false;
  herd = new ArrayList<Cloud>(); // <--- hmm
  portalTrig = false;
  entry = new ArrayList<Portal>();

  demos = new ArrayList <BasicShapeElement>(); 
  locations = new ArrayList<PVector>();
  /*
  clouds = new ArrayList<Cloud>();
   
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
}

void draw() {
  background(0);

  /* // ************* old code (before refactor)
   // if we have shapes, run them as clouds:
   if (herd.size() >= 1) {
   for (int i = herd.size()-1; i >= 0; i--) {
   Cloud temp = herd.get(i);
   temp.run();
   if (temp.tooOld()) {
   herd.remove(i);  // remove a shape cloud kernel from the cloud mass
   }
   }
   // randomly kill off a few _shapes_ from within the cloud herd
   if (frameCount % 8 == 0) {
   for (int i = 5; i < 0; i--) {
   // /*
   int rando = floor(random(0, herd.size()-1));
   Cloud temp = herd.get(rando);
   temp.plague(); //*/
  //^^ || vv is more effective?
  //float whichOne = abs(random(1, herd.size()));
  // herd.remove(whichOne); 
  /*
      }
   } 
   } //herd runs and checks
   */

  //  *****************re-coding below to work for multiple people with Max:
  /*
  // portal trigger: VVVVVVVVV  ; <<--- reconfig
   long stamp = millis();
   // if we have been sitting for a bit in one place, but not super long:
   if (((stamp - movedStamp) > 2000) && ((stamp - movedStamp) < 15000) ) {
   //triggerPortal();  ///<-- commented out for testing
   } else {
   //portalTrig = false;
   } // if sitting
   //print("portBirth: "); 
   //println(portBirth);
   
   // need to be able to have more than one. 
   
   // if the we haven't moved:  <----- eyeyaiyyiyiy
   if (newSpot == false) { //if ((millis() - portBirth < 10000)) {
   // if we are not  on the edges of the screen:
   if (lastMouseX > 10 && lastMouseX < (width - 10) && (lastMouseY > 10 && lastMouseY < (height -10)) ) {
   // if we are in the same spot:
   //if (newSpot == false) { 
   //if (entry.size() > 0) {
   // run the portals:
   for (int i = entry.size()-1; i >= 0; i--) {
   Portal temp = entry.get(i);
   temp.featureShifter();
   //temp.shift();
   if (20000 > (millis() - portBirth)) {
   temp.grow();
   } else {
   maturePort = true;
   //println("port is mature");
   }
   temp.display();
   //println("display, move");
   }
   }// not on edges
   } //young
   
   // if we are too old, or if we are in a new spot, kill portals:
   if ( newSpot == true) { //(millis() - portBirth) > 10100 ||
   // portalTrig = false;
   
   // if we are mature, shrink a bit before wiping out:
   if (maturePort == true && shrinking == false) {
   //println("shrinking");
   for (int i = entry.size()-1; i >= 0; i--) {
   Portal temp = entry.get(i);
   shrinking = temp.shrink();  // clean out array
   }
   //portBirth = 0; //<<--
   } else if (shrinking == true) {
   // now remove them
   //println("removing ");
   for (int i = entry.size()-1; i >= 0; i--) {
   entry.remove(i);  // clean out array
   }
   portBirth = 0; //<<--
   }
   } 
   */  //********** end stuff to re-code  
  //*/

  //************************ refactor is below:

  // run the demos if we have any:
  if (demos.size() > 0) {
    println(demos.size());

    for (int i= demos.size()-1; i >= 0; i--) {
      BasicShapeElement shape = demos.get(i); // <--- hmmm
      //shape.display(true, 30, 100, 200, 100); 
      expandShrink();
      shape.display();
      boolean dead = shape.update();
      //print("are we dead?  ");
      //println(dead);
      if(dead) {   
        demos.remove(i);  // if we remove one, breaks out of loop and stops
        println("removed one");  // displaying rest, until loop is restored
      } else continue;  // continue keeps the for-loop running

    }
    //println("no values");
    if (locations.size() > 100) {
      locations_indice = 0;
    }
  }
} // draw loop

void expandShrink(){
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
   
   /* this isn't working correct
   desired: when close: shape expands
            when far: shape shrinks
   
   */
   for(BasicShapeElement shapie: demos){
     if (shapie.centerX < (mouseX + distDiff) || shapie.centerX < (mouseX - distDiff) ||
      shapie.centerY  < (mouseY + distDiff)  || shapie.centerY  < (mouseX - distDiff) ) {
        shapie.shrink();
      } // if we are close
      else {
        shapie.expand();
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
  // create testers here:
  //BasicShapeElement tester = new BasicShapeElement(mouseX, mouseY, 5, 25);
  //append(demos, tester);
  //demos.add(0, tester);
}

void mouseMoved() {
  // create testers here:
  BasicShapeElement tester = new BasicShapeElement(mouseX, mouseY, 5, 25);
  //append(demos, tester);
  demos.add(0, tester);
  //tester = demos[0];
}

/*
void mouseMoved() { // <----- revise this!
 //if we have moved a lot
 if ( ( screenLoc[0]  > (lastRecMouseX + distDiff)  || screenLoc[0]  < (lastRecMouseX - distDiff)) ||
 ( screenLoc[1]  > (lastRecMouseY + distDiff)  || screenLoc[1]  < (lastRecMouseY - distDiff)) ) {
 fish = new Cloud(screenLoc[0], screenLoc[1] );
 herd.add(fish);
 // record locations and time
 lastRecMouseX = screenLoc[0] ;
 lastRecMouseY = screenLoc[1] ;
 movedStamp = millis();
 newSpot  = true;
 } else {
 newSpot = false;
 lastMouseX = screenLoc[0] ;
 lastMouseY = screenLoc[1] ;
 }
 // print("newSpot is:  "); 
 // println(newSpot);
 }
 */

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  // println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  // println(" addrpattern: "+theOscMessage.addrPattern());
  //theOscMessage.print();

  // splice theOscMessage.addrPattern()
  //areWeRunning = true;
  String [] newLocations = splitTokens(theOscMessage.addrPattern());
  for (int i =0; i < newLocations.length; i ++) {
    screenLoc[i] = int(newLocations[i]);
  }
  print(screenLoc[0]); 
  print(", ");
  println(screenLoc[1]);
  //println(theOscMessage.addrPattern().length());
  int tempX = int(screenLoc[0]);
  int tempY = int(screenLoc[1]);
  PVector newLoc = new PVector(tempX, tempY);
  /*
  if (locations_indice == 0) {
    fish = new Cloud(tempX, tempY);  // <--- not sure about this
    // keeping track of locations:
    //locations = (PVector[])append(locations, (new PVector(tempX, tempY)));
    //locations[0] = new PVector(tempX, tempY);
    herd.add(fish);
    //println("new fish added");
    //firstLoc = false;
  } else {
    locations_indice++;
    newSpot(newLoc);
  }
  */
}

void newSpot(PVector newbie) {
  for (PVector i : locations) {
    // check to see if new spot is a new location; if so, create a new fish:
    if (newbie.x > (i.x + distDiff) || newbie.x < (i.x - distDiff) ||
      newbie.y  > (i.y + distDiff)  || newbie.y  < (i.y - distDiff) ) {
      //println("make new cloud");
      fish = new Cloud(int(newbie.x), int(newbie.y));  // <--- not sure about this
      //locations = (PVector[])append(locations, (new PVector(int(newbie.x), int(newbie.y))));
      // locations[locations_indice] = new PVector(int(newbie.x), int(newbie.y));
      herd.add(fish);
      //println("new fish added");
    }// possible is new locations 
    else {
      float timeStamp = millis();
      //println("not a new position");
      // then store in an array that is same size as locations
      // then else where, we can use this to see if we've been at a spot for a long
      // enough time to create a portal
    }
  } // for current locations
}
