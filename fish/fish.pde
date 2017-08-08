/*  //<>//
 locs holds 5 locations, which are updated in draw with ref to the mouse
 new shapes are "born" and intitally active with reference to the mouse
 
 
 */

//Shape portal = new Shape();
//Shape[] cloud = new Shape[30];
ArrayList<Shape> cloud = new ArrayList<Shape>();
ArrayList<Shape> portals = new ArrayList<Shape>();
Shape m;
int limit = 5;  // number of shapes
PVector[] locs = new PVector[limit];  // locations of shapes
int incrementer = 0;
//float r_ = 30;
long lastMove;
long still_interval = 3000;
boolean w = false;

void setup() {
  size(displayWidth, displayHeight); 
  //size(600, 600);

  background(0);
  /*
  // create a whole bunch of initial locations
   for (int i = 0; i < limit; i++) {
   PVector temp = new PVector((width*0.25), (height*0.25));
   //temp.mult(random(-3, 3));
   locs[i] = temp;
   //println(locs[i]);
   }
   */
}

void draw() {
  background(0);
  //updateLocations();  //update locations for newbies, with ref to the mouse
  //r_+= 30;
  //if (r_ > width) r_ = 0;
  /*
  // check to see if the opacity + cloud are dead. If so, get rid of them
   if (cloud.size() >= 1) {  // if there is more than 2 shapes
   for (int i = ((cloud.size()-1) - limit); i >= 0; i--) {
   //for (int i = 0; i <=  cloud.size()-1; i++) {
   Shape temp = cloud.get(i);
   temp.check();
   if (temp.dead == true) {
   cloud.remove(i);
   }
   }
   }
   */

  // want to run backwards, because new ones are added on the end (with mouse locations)
  //want them on the bottom of the stack
  // versus history of each location.older ones should appear first.
  //run each shape in the cloud array
  int cld_size = cloud.size()-1;
  //println(cld_size);
  //int elders = cld_size - limit;
  if (cld_size > 0) {
    boolean tracking = false;
    for ( int i = cld_size; i >= 0; i--) {
      Shape temp = cloud.get(i);
      //temp.check();
      temp.run(tracking);
      // check to see if the opacity + cloud are dead. If so, get rid of them
      // but not on the last 5, since they are new.
      //if( i <= elders){  // mucks with slow fade; so took it out
      temp.check();
      if (temp.dead == true) {
        cloud.remove(i);
      }
      //} // elders 
      //temp.interaction();
    }
  }

  //shiftCloud();
  //*************************
  // TO DO:
  // 1. create a class based off of shape for portals
  // 2. control radius to expand but up to a point
  // 3. need to figure out how/when to kill/transition 
  // 4. as well as the fade of the portal rings ...? or when kill?
  
  // create a portal  <--- need to do this separate from the shapes currently present
  if ((millis() - lastMove) > still_interval) {
    portals();  // create the portals
    lastMove = millis(); // turn us off
  }

  int portals_size = portals.size()-1;
  if (portals.size() != 0) { // if we have some portals, run them:
    //w = true;
    for (int i = portals_size; i >= 0; i--) {
      Shape temp2 = portals.get(i);
      temp2.run();
      
      // after so long, kill portal:
      // need to figure out how long to keep them
      temp2.check();
      if (temp2.dead == true) {
        portals.remove(i);
      }
    }
  }
} // draw loop

/* not needed: 
 void shiftCloud() {
 for (int i = 0; i < cloud.size()-1; i ++) {
 Shape temp = cloud.get(i+1);
 cloud.set(i, temp);
 }
 }
 */

void updateLocations() { //float r
  //float theta = 0;
  //float r = 30;
  float theta = 0;
  float dx, dy;
  //update new location options  with reference to the mouse
  PVector m = new PVector(mouseX, mouseY);
  for (int i = 0; i < limit; i++) {
    float r = random(30, 80);  // losens it to not be a curve
    ///*
    float rad = radians(theta);
    //dx = radius * cos(rad);
    //dy =  radius * sin(rad);
    dx = r * cos(rad);
    dy =  r * sin(rad);

    PVector loc = new PVector(dx, dy);
    loc.add(m);
    // PVector loc = locs[i];
    //PVector newLoc = PVector.sub(loc, m);
    //locs[i] = newLoc.add(locs[i]);
    locs[i] = loc;
    //locs[i].add(loc);  // if do this, need to restrain to screen
    //theta = theta + 0.01;
    theta = theta + (360/limit);
    if (theta >= 360) theta = 0;
  }
}

///*
void mouseMoved() {
  w = false;  // stop making portals
  //portal.newLoc(mouseX, mouseY);
  //int rand = int(random(10, 30));
  //cloud.add(new Shape(mouseX, mouseY, rand));
  updateLocations();  // update locations of newbies, with ref to mouse. more sense to have this here

  Shape newbie;
  // adding 5 more each time
  // many around the mouse, fade away
  // with # same as limit get a field or a ring if radius isn't random
  for (int i = 0; i < limit; i++) {  // one shape each loop + update locations
    int randy = int(random(2, 5)); // how many rings in this shape?
    newbie = new Shape(int(locs[i].x), int(locs[i].y), randy);
    //newbie.run(); // don't run them here, lest black dots
    cloud.add(newbie);
  }

  //Shifting all the locations of the shapes arrays:
  /*
  for (int i = 0; i < cloud.size()-1; i++) {
   //for (int i = cloud.size()-1; i >= 0; i--) {
   Shape temp = cloud.get(i);
   temp.update();
   }
   */
  lastMove = millis();  // time stamp from last moved
} // mouseMove()y//*/

void portals() {
  Shape newbie;
  for (int i = 0; i < limit; i++) {  // one shape each loop + update locations
    int randy = int(random(2, 5)); // how many rings in this shape?
    //newbie = new Shape(int(locs[i].x), int(locs[i].y), randy);
    newbie = new Shape(mouseX, mouseY, randy);
    //newbie.run(); // don't run them here, lest black dots
    portals.add(newbie);
  }
}