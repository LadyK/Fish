import oscP5.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import netP5.*;
import java.util.Map;
import codeanticode.syphon.*; // send back to max, which funnels it to machine running projection mapping

PGraphics canvas; // need this for projection mapping thru syphon via madmapper
SyphonServer server;

int checker = 0;
int loopChecker = 0;
OscP5 whereimlistening; // equivalent to [udpreceive] in max, e.g. it's listening
NetAddress whereimsending; // equivalent to [udpsend] in max - it's sending
OscP5 oscP5send;
String messageselector;




/* a NetAddress contains the ip address and port number of a remote location in the network. */

// need graphics to be more responsive to max values. spread north + south?



Integer[] screenLoc = {0, 0};
//ArrayList <PVector> all_locations;
//PVector[] locations;


ArrayList <Cloud> demos;
//BasicShapeElement[] demos;
ArrayList <Portal> portals;


ArrayList<Shape> triggers;

//HashMap<String, Cloud> storm = new HashMap<String, Cloud>();

boolean trigger;
//int distDiff= 10; // how much of a difference in mouse location needed
long movedStamp;
boolean portalTrig;
//Portal entry;
//ArrayList<Portal> entry;
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

float  rd, gn, blu, rdshift, gnshift, blushift;
color  kuler, paint, previousKuler, lerpKuler;
long intervalPortMin, intervalPortMax;

//fish:
int octaves = 4;
float falloff = 0.3;
float noiseScale = 0.2;

color midColor, topColor, bottomColor, interColor;
float threshold = 0.90;

School school;
boolean fish;



void setup() {
  size(640, 480, P3D);  // need to send less to max to send out? 800?
  //canvas = createGraphics(1280, 1024, P3D); // out to syphon

  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  //size(displayWidth, 300 ); 
  //  size(800, 800, P3D);
  //frameRate(30);
  //background(0);
  colorMode(RGB, 1.0, 1.0, 1.0, 255);

  //colorMode(HSB, 255);

  trigger = false;
  // herd = new ArrayList<Cloud>(1000); // <--- hmm
  // herd = new ArrayList[1000];
  //all_locations = new PVector[1000];
  // all_locations = new ArrayList<PVector>(1000);
  //BasicShapeElement[] demo = new BasicShapeElement[2000];
  portals = new ArrayList<Portal>(1);
  demos = new ArrayList<Cloud>(50);
  triggers = new ArrayList<Shape>(10);
  portalTrig = false;

  rd = 0;
  gn = random(1);  // 128, 255
  blu = random(1); // 0, 192
  kuler = color(rd, gn, blu);
  intervalPortMin = 6000;   // 6 seconds
  intervalPortMax = 10000;


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
  oscP5send = new OscP5(this, 12003);
  whereimsending = new NetAddress("192.168.0.77", 12003); // hostname, port PORTAL info
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  /* start oscP5, listening for incoming messages at port 12000 */
  whereimlistening = new OscP5(this, 12000); // takes tracking values from Max

  //screenLoc[0] = 0;
  //screenLoc[1] = 0;
  currentLocation = new PVector(-400, -400);
  //  PVector tester = new PVector(mouseX, mouseY);
  newSpot(currentLocation);
  //  previousMouse = new PVector(-100, -200);
  
  //Fish:
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
    cameraZ/10.0, cameraZ*10.0);
  //perspective();
  school = new School();
  PVector loc = new PVector(width/2, height/2);
  for (int i = 0; i < 15; i++) {
    Fish f = new Fish(loc);
    school.addFish(f);
  }
  shimmer = 127;
   noStroke();
   noiseDetail(octaves, falloff);
  topColor = color(160);
  midColor = color(127);
  bottomColor = color(100);
  fish = true;
}

void draw() {

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
   
 colorMode(RGB, 1.0, 1.0, 1.0, 255);
  siblingsCheck(); // are all of the clouds fully formed with all of their shapes? (getting the to appear/form a bit morme gradually)

  // run the demos if we have any:
  if (demos.size() > 0) {
    fish = false;
    colorChange(); // not sure why opacity is so bright when controlling color here, versus within the class
    // print("Demos is: ");
    // println(demos.size()-1);
    for (int i= demos.size()-1; i >= 0; i--) {
      // PVector loc = all_locations.get(i);
      Cloud c = demos.get(i);
      if (c.shapes.size() <= 0) { // if the size of the shapes array (ie, cloud elements) in the cloud object is (nearly) empty
        demos.remove(i);
        //   println("removed one");
      } else {  // too few, fast and a glitch:
        //if (frameCount % 93 == 0) {
        //  if (c.siblings == c.howMany) { // if we've reached our siblings max, skip
        //    continue;
        //  } else { // otherwise, create a new one:
        //    c.randX = int(random(-c.randoX, c.randoX)) + int(c.loc.x);
        //    c.randY = int(random(-c.randoY * 8, (c.randoY * .2))) + int(c.loc.y); // increase this along the y-axis via for-loop ?
        //    BasicShapeElement temp = new BasicShapeElement(c.randX, c.randY, 7, c.radius, c.howMany, c.alpha, c.rando); 
        //    c.shapes.add(0, temp);
        //    c.siblings++;
        //  }
        //}

        c.run();
      }
    }
  } else if (demos.size() == 0 || fish == true){
    if(frameCount % 46 == 0) colorChange();
     //fish:
  colorMode(RGB, 255, 255, 255);
  spotLight(254, 252, 203, width/4, 0, 200, 0, 0, -1, PI/4, 8);
  spotLight(254, 252, 203, (width/4) * 3, 0, 400, 0, 0, -1, PI/4, 4);
  pointLight(170, 217, 224, 100, height/2 + 200, 4);
  pointLight(170, 217, 224, width - 100, height/2 + 200, 4);
  spotLight(254, 252, 203, width/2, height/2, 0, 0, 0, -1, PI/2, 4);
  colorMode(RGB, 1.0, 1.0, 1.0, 255);
  school.run();

    
    
  }
  // run triggers/rings feedback on user presence:

  for (int i = triggers.size()-1; i >= 0; i--) {
    Shape s = triggers.get(i);
    if (s.o <= 1) {
      triggers.remove(i);
      // println("Trigger removed");
    } else {
      s.update_();
    }
  }

  //for (int i = portals.size()-1; i >=0; i--) {
  // Portal p_ = portals.get(i);
  //  p_.runClouds(); // including it's clouds
  //}

  // run portals:
  // /*
  for (int i = portals.size()-1; i >=0; i--) {
    Portal p_ = portals.get(i);
    if (p_.pcloudsAppear == true) { // maybe when flip this to false, drain out shapes and clean up array?
      p_.runClouds(); // including it's clouds
    }
    // where are we getting rid of old/bad portals?? <-- figure this out
    //p_.featureShifter();
    long b = p_.birth;
    //   print("birth is: ");
    //    println(b);
    long stamp = millis() - b;
    //   println(stamp);
    // when the portal is young, have it expand
    if (stamp < 15000) { // the portals can only last so long. make sure they are young
      // if it's a bit older, shift it a bit:
      if (stamp > 3000 && frameCount % 2 == 0) {
        p_.featureShifter(1);
        p_.pcloudsAppear = true;  // clouds appear  <--- took this out to speed up code
      }
      p_.expand_(); //grow();
      p_.display(true, stamp);
    }
    // if we are even older, start the clouds behind it:
    else if ( stamp > 15000 && stamp < 25000) {
      p_.runClouds();  // not sure if this is working ***

      p_.featureShifter(1);
      p_.display(true, stamp);
    } // if we are old, start shrinking:
    else if (stamp >= 25000 && stamp < 36000) {
      if (frameCount % 2 == 0) {
        p_.featureShifter(1);
      }
      p_.textop = false;
      p_.runClouds(); //more vibrant glitter // was also turned off before ***
      p_.shrink();
      p_.display(true, stamp);
    } else {
      //if (frameCount % 2 == 0) {
      //  p_.featureShifter(1);
      //}
      p_.textop = false;
      p_.runClouds(); // also was off
      p_.display(true, stamp);  //here: eventually expands portal
      p_.shrink();

      if (stamp > 39000) {
        //delay(500);
        stamp = 0;
        // why does still expand a touch before being removed?
        portals.remove(i);
        println("portal removed");
        println(p_.portalClouds.size());
      }
    }
  }
  
  server.sendScreen(); // sends screen to max to send out
  
} // draw loop


void siblingsCheck() {  // change clouds so first one appears at source, then the rest appear N/S of source on fibers
  if (frameCount % 3 == 0) {
    for (int i= demos.size()-1; i >= 0; i--) {  // since new ones are added to the end, start there
      // PVector loc = all_locations.get(i);
      Cloud c = demos.get(i);
      if (c.siblings != c.howMany) { // if we've reached our siblings max, skip
        // continue;
        //} else { // otherwise, create a new one:
        c.randX = int(random(-c.randoX, c.randoX)) + int(c.loc.x);
        c.randY = int(random(-c.randoY * 8, (c.randoY * .2))) + int(c.loc.y); // increase this along the y-axis via for-loop ?
        BasicShapeElement temp = new BasicShapeElement(c.randX, c.randY, 7, c.radius, c.howMany, c.alpha, c.rando); 
        c.shapes.add(0, temp);
        c.siblings++;
      }
    }
  } // frameCount
}

void colorChange() {

  //previousKuler = color(abs(rd * .3), abs(gn * .2), abs(blu * .3));

  float curTime = millis()/1000.0;
  // c_rand = random(0.5, 0.6);
  // curTime = c_rand * curTime;

  //println(curTime);
  //if (frameCount % 10 == 0) {
  for (int i=0; i< numColors; i++) {

    rd = sin(curTime * 0.8f + i * 0.0011f) + 0.5f; //R  + 0.8f
    gn = sin(curTime * 0.7f + i * 0.0013f) + 0.5f; //G * 0.5f + 0.5f   + 0.5f
    blu = sin(curTime * 0.3f + i * 0.0017f) + 0.5f; 
    rdshift = abs(rd - .5);
    gnshift = abs(gn - .5);
    blushift = abs(blu - .5);
    rd = abs(rd);
    gn = abs(gn);
    blu = abs(blu);
    kuler = color(rd, gn, blu);

    previousKuler = color(rdshift, gnshift, blushift);
  }
  
  topColor = kuler;
  midColor = lerpKuler;
  bottomColor = previousKuler;

  paint = kuler;
  lerpKuler = lerpColor(paint, previousKuler, 0.5);
  
   
}


//void triggerPortal(PVector l) {
//  //print("num of portals: ");
//  //println(entry.size());
//  // if we dont have portals, create some:
//  //if (portals.size() < 0 && portBirth <= 0) {
//  //for (int i = 0; i < 5; i++) {
//  //int randX = 0; //int(random(-5, 5));
//  // int randY = 0; //int(random(-5, 5));
//  //Portal temp = new Portal(screenLoc[0] + randX, screenLoc[1]  + randY, 10, 15);
//  Portal temp = new Portal(l.x, l.y, 5, 60);
//  portals.add(temp);
//  //  portalTrig = false;
//  //}
//  // portBirth = millis();
//  //}
//}

void mousePressed() {

  /*
// if (frameCount % 2 == 0) {
   float randX = random((-radius), (radius));
   float randY = random((-radius), (radius));
   PVector tester = new PVector(mouseX + randX, mouseY + randY);
   currentLocation = newSpot(tester);   //send location to be checked. then made a new one elsewhere
   // }
   */

  PVector newLoc = new PVector(mouseX, mouseY);
  if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
    //newLoc.x = map(newLoc.x, 0, 640, 0, width);
    //newLoc.y = map(newLoc.y, 0, 480, 0, height);
    flash(newLoc); // ring triggers
    newSpot(newLoc); // new cloud
    //println();
    //println("new cloud and ring");
    //println("Made new cloud");
  } else if (checkLocations(newLoc) == true) {
    // println("none made");
  }
}

void keyPressed() {

  print("Demos is: ");
  println(demos.size());
  print("Triggers is: ");
  println(triggers.size());
  print("Portals is: ");
  println(portals.size());

  for (int i = portals.size()-1; i >=0; i--) {
    Portal p_ = portals.get(i);
    print("portalClouds is: ");
    println(p_.portalClouds.size());
  }

  if (key == 32) {
    noLoop();
  }
  if (key == 'z') {
    loop();
    print(mouseX, mouseY);
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


/*  testing purposes only
  PVector newLoc = new PVector(mouseX, mouseY);
  if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
    // strained because of masking in madmapper re:studio prototype
    //newLoc.x = map(newLoc.x, 0, 640, 104, 450);
    //newLoc.y = map(newLoc.y, 0, 480, 0, height);

    flash(newLoc); // ring triggers
    newSpot(newLoc); // new cloud
    //println();
    //println("new cloud and ring");
    //println("Made new cloud");
  } else if (checkLocations(newLoc) == true) {
    // println("none made");
  }
 */ 
 
}


boolean checkLocations(PVector nLoc) {
  // print("demo size: "); 
  //println(demos.size());
  //boolean tooClose = false; // what the point of putting this here? mucks it all up
  for (int i= demos.size()-1; i >= 0; i--) {
    // PVector loc = all_locations.get(i);
    Cloud c = demos.get(i);
    //Shape s = triggers.get(i);
    if (c.tooclose(nLoc) == true ) { // if we are too close to a previous spot:
      //tooClose = true;
      //if(portals.size() > 0){
      // portals are too close to one another. need to check the location of portals as well:
      //for (int j = portals.size()-1; j >=0; j--) {
      //  Portal p_ = portals.get(j);
      //  println("can we make a portal?");
      //   if (p_.tooclose(nLoc) == false) { // if we are not on top of another portal
      //  println("making...");

      // currently: cloud life is shorter, than portal. should be independent? Or portal launch clouds around if still there?
      if (c.portalTrigger == false) {  // and we do not have a portal for this cloud...
        //  println("making a portal");
        //launch a portal if we've been there awhile:
        if ((millis() - c.birth > intervalPortMin) && (millis() - c.birth < intervalPortMax)) {   //portal work***
          Portal temp = new Portal(nLoc.x, nLoc.y, 5, 20); // make a new portal  points, radius
          portals.add(temp); // add it to the array
          c.portalTrigger = true;
          //send portal trigger to Max:
           OscMessage portalTrigger = new OscMessage("");
          // portalTrigger.add(1); /* add an int to the osc message */
           portalTrigger.add(nLoc.y);
           portalTrigger.add(nLoc.x);
          /* send the message */
          oscP5send.send(portalTrigger, whereimsending);  
        }
      }else if (c.portalTrigger == true) {
        println("doing nothing. no creation.");
      }
      //  }
      //}
      //}
      //break; // do we really want this here?
      return true;
    } else {
    }
  }
  // none of the clouds are close so, thus make a new cloud
  return false;  // which will then make a new cloud
}

boolean checkTriggers(PVector nLoc) { // rings that communicate feedback
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
  //    println("got an event");

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
  //print("new location is: ");
  //println(newLoc);
  if (checkLocations(newLoc) == false && checkTriggers(newLoc) == false) { // <---- same spot?
    //newLoc.x = map(newLoc.x, 0, 640, 0, width);
    newLoc.x = map(newLoc.x, 0, 640, 124, 500);  // strained because of masking in madmapper
    //newLoc.x = constrain(newLoc.x, 104, 376);
    newLoc.y = map(newLoc.y, 0, 480, 0, height);
    flash(newLoc); // ring triggers
    newSpot(newLoc); // new cloud
    //println("new cloud and ring");

    // println("Made new cloud");
  } else if (checkLocations(newLoc) == true) {
    // println("none made");
  }
}



void flash(PVector l_) {
  Shape spot = new Shape(int(l_.x), int(l_.y), 20, ius); //7
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
  Cloud tester = new Cloud(newbie, 50, 15, 60, 40, false);  // loc, prox, radius, # (was 30), o, portalRelated?  ***** <----- new cloud here
  //println(tester.birth);
  demos.add(tester); // took out (0, tester)
  //}
  //all_locations.add(newbie);
  //println("new spot added");
  return newbie;
}
