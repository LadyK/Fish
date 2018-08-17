/*  //<>//
 locs holds 5 locations, which are updated in draw with ref to the mouse
 new shapes are "born" and intitally active with reference to the mouse
 
 adding blob detection thru openCV using the kinect
 
 kinect --> openCV --> blob detection
 */

import gab.opencv.*;
import java.awt.*;
import processing.video.*;
import controlP5.*;
import org.openkinect.processing.*;

import org.openkinect.freenect.*;

OpenCV opencv;
Capture video;


ArrayList<Contour> contours;

// List of detected contours parsed as blobs (every frame)
ArrayList<Contour> newBlobContours;

// List of my blob objects (persistent)
ArrayList<Blob> blobList;

// Number of blobs detected over all time. Used to set IDs.
int blobCount = 0;

float contrast = 1.35;
int brightness = 0;
int threshold = 75;
boolean useAdaptiveThreshold = false; // use basic thresholding
int thresholdBlockSize = 489;
int thresholdConstant = 45;
int blobSizeThreshold = 20;


// Kinect Library object
//Kinect2 kinect2;
Kinect kinect;

float minThresh = 536; // 480;
float maxThresh = 673; //830;
PImage img;
float aX, aY;



//Shape portal = new Shape();
//Shape[] cloud = new Shape[30];
ArrayList<Shape> cloud = new ArrayList<Shape>();
ArrayList<Portal> portals = new ArrayList<Portal>();
Shape m;
int limit = 5;  // number of shapes
PVector[] locs = new PVector[limit];  // locations of shapes
int incrementer = 0;
//float r_ = 30;
long lastMove;
long still_interval = 1500;
boolean w = false;

void setup() {
  size(displayWidth, displayHeight, P2D); 
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
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(true);

  img = createImage(kinect.width, kinect.height, RGB);
  //video = new Capture(this, kinect.width, kinect.height, );
  //opencv = new OpenCV(this, 512, 424);
  opencv = new OpenCV(this, displayWidth, displayHeight);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

  contours = new ArrayList<Contour>();

  // Blobs list
  blobList = new ArrayList<Blob>();
  // Set thresholding
  //toggleAdaptiveThreshold(useAdaptiveThreshold);
}

void draw() {
  background(0);

  img.loadPixels();
  /*
  minThresh = map(mouseX, 0, width, 0, 4500);
   maxThresh = map(mouseY, 0, height, 0, 4500);
   print("min is:  "); println(minThresh);
   print("max is:  ");  println(maxThresh);
   */
  int[] depth = kinect.getRawDepth();
  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;
  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh ) { //&& x > 100
        img.pixels[offset] = color(255, 0, 150);

        sumX += x;
        sumY += y;
        totalPixels++;
      } else {
        img.pixels[offset] = color(0);
      }
    }
  }
  img.updatePixels();
  image(img, 0, 0);



  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;

  aX = map(avgX, 0, kinect.width, 0, displayWidth);
  aY = map(avgY, 0, kinect.height, 0, displayHeight);
  fill(150, 0, 255);
  //ellipse(aX, aY, 64, 64);
  opencv.loadImage(img);
  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }


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
    //boolean tracking = false;
    for ( int i = cld_size; i >= 0; i--) {
      Shape temp = cloud.get(i);
      //temp.check();
      temp.run();
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

  // 2. control radius to expand but up to a point
  // 3. need to figure out how/when to kill/transition 
  // 4. as well as the fade of the portal rings ...? or when kill?

  // create a portal  <--- need to do this separate from the shapes currently present
  if ((millis() - lastMove) > still_interval) {
    portals();  // create the portals
    lastMove = millis(); // turn us off
  }

  int portals_size = portals.size()-1;
  if ((millis() - lastMove) < still_interval) {
    if (portals.size() != 0) { // if we have some portals, run them:
      //w = true;
      for (int i = portals_size; i >= 0; i--) {
        Portal temp2 = portals.get(i);
        temp2.run();

        // after so long, kill portal:
        // need to figure out how long to keep them
        temp2.check();
        if (temp2.dead == true) {
          portals.remove(i);
        }
      }
    }
  } // smaller than interval, not moving
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
  PVector m = new PVector(aX, aY);
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
  if ((mouseX != pmouseX) || (mouseY != pmouseY)) {
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
  }
  lastMove = millis();  // time stamp from last moved
} // mouseMove()y//*/

void portals() {
  Portal newbie;
  for (int i = 0; i < limit; i++) {  // one shape each loop + update locations
    int randy = int(random(2, 7)); // how many rings in this shape?
    //newbie = new Shape(int(locs[i].x), int(locs[i].y), randy);
    //newbie = new Portal(mouseX, mouseY, randy, 2);
    newbie = new Portal(int(aX), int(aY), randy, 1);
    //newbie.run(); // don't run them here, lest black dots
    portals.add(newbie);
  }
}


void displayBlobs() {

  for (Blob b : blobList) {
    strokeWeight(1);
    b.display();
  }

  if (blobList.size() > 3) {
    println("ding ding");
  } else {
    println("none");
  }
}

void displayContours() {

  // Contours
  for (int i=0; i<contours.size(); i++) {

    Contour contour = contours.get(i);

    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    contour.draw();
  }
}

void displayContoursBoundingBoxes() {

  for (int i=0; i<contours.size(); i++) {

    Contour contour = contours.get(i);
    Rectangle r = contour.getBoundingBox();

    if (//(contour.area() > 0.9 * src.width * src.height) ||
      (r.width < blobSizeThreshold || r.height < blobSizeThreshold))
      continue;

    stroke(255, 0, 0);
    fill(255, 0, 0, 150);
    strokeWeight(2);
    rect(r.x, r.y, r.width, r.height);
    //println(r.x);
  }
}

////////////////////
// Blob Detection
////////////////////

void detectBlobs() {

  // Contours detected in this frame
  // Passing 'true' sorts them by descending area.
  contours = opencv.findContours(true, true);

  newBlobContours = getBlobsFromContours(contours);

  //println(contours.length);

  // Check if the detected blobs already exist are new or some has disappeared. 

  // SCENARIO 1 
  // blobList is empty
  if (blobList.isEmpty()) {
    // Just make a Blob object for every face Rectangle
    for (int i = 0; i < newBlobContours.size(); i++) {
      println("+++ New blob detected with ID: " + blobCount);
      blobList.add(new Blob(this, blobCount, newBlobContours.get(i)));
      blobCount++;
    }

    // SCENARIO 2 
    // We have fewer Blob objects than face Rectangles found from OpenCV in this frame
  } else if (blobList.size() <= newBlobContours.size()) {
    boolean[] used = new boolean[newBlobContours.size()];
    // Match existing Blob objects with a Rectangle
    for (Blob b : blobList) {
      // Find the new blob newBlobContours.get(index) that is closest to blob b
      // set used[index] to true so that it can't be used twice
      float record = 50000;
      int index = -1;
      for (int i = 0; i < newBlobContours.size(); i++) {
        float d = dist(newBlobContours.get(i).getBoundingBox().x, newBlobContours.get(i).getBoundingBox().y, b.getBoundingBox().x, b.getBoundingBox().y);
        //float d = dist(blobs[i].x, blobs[i].y, b.r.x, b.r.y);


        if (d < record && !used[i]) {
          record = d;
          index = i;
        }
      }
      // Update Blob object location
      used[index] = true;
      b.update(newBlobContours.get(index));
    }
    // Add any unused blobs
    for (int i = 0; i < newBlobContours.size(); i++) {
      if (!used[i]) {
        println("+++ New blob detected with ID: " + blobCount);
        blobList.add(new Blob(this, blobCount, newBlobContours.get(i)));
        //blobList.add(new Blob(blobCount, blobs[i].x, blobs[i].y, blobs[i].width, blobs[i].height));
        blobCount++;
      }
    }

    // SCENARIO 3 
    // We have more Blob objects than blob Rectangles found from OpenCV in this frame
  } else {
    // All Blob objects start out as available
    for (Blob b : blobList) {
      b.available = true;
    } 
    // Match Rectangle with a Blob object
    for (int i = 0; i < newBlobContours.size(); i++) {
      // Find blob object closest to the newBlobContours.get(i) Contour
      // set available to false
      float record = 50000;
      int index = -1;
      for (int j = 0; j < blobList.size(); j++) {
        Blob b = blobList.get(j);
        float d = dist(newBlobContours.get(i).getBoundingBox().x, newBlobContours.get(i).getBoundingBox().y, b.getBoundingBox().x, b.getBoundingBox().y);

        //float d = dist(blobs[i].x, blobs[i].y, b.r.x, b.r.y);
        if (d < record && b.available) {
          record = d;
          index = j;
        }
      }
      // Update Blob object location
      Blob b = blobList.get(index);
      b.available = false;
      b.update(newBlobContours.get(i));
    } 
    // Start to kill any left over Blob objects
    for (Blob b : blobList) {
      if (b.available) {
        b.countDown();
        if (b.dead()) {
          b.delete = true;
        }
      }
    }
  }

  // Delete any blob that should be deleted
  for (int i = blobList.size()-1; i >= 0; i--) {
    Blob b = blobList.get(i);
    if (b.delete) {
      blobList.remove(i);
    }
  }
}

ArrayList<Contour> getBlobsFromContours(ArrayList<Contour> newContours) {

  ArrayList<Contour> newBlobs = new ArrayList<Contour>();

  // Which of these contours are blobs?
  for (int i=0; i<newContours.size(); i++) {

    Contour contour = newContours.get(i);
    Rectangle r = contour.getBoundingBox();

    if (//(contour.area() > 0.9 * src.width * src.height) ||
      (r.width < blobSizeThreshold || r.height < blobSizeThreshold))
      continue;
    //Make an ellipse on the blob
    fill(255, 0, 0);
    //ellipse(r.x+50, r.y+50, 50, 50);
    //
    newBlobs.add(contour);
  }

  return newBlobs;
}