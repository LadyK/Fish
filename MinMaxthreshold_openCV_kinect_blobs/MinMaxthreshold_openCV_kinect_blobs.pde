import gab.opencv.*;
import java.awt.Rectangle;
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
float maxThresh = 573; //830;
PImage img;

void setup() {
  size(512, 424);
  //kinect2 = new Kinect2(this);
  kinect = new Kinect(this);
  //kinect2.initDepth();
  //kinect2.initDevice();
  kinect.initDepth();
  kinect.enableMirror(true);

  //img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  img = createImage(kinect.width, kinect.height, RGB);

  opencv = new OpenCV(this, 512, 424);
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

  // Get the raw depth as array of integers
  //int[] depth = kinect2.getRawDepth();
  int[] depth = kinect.getRawDepth();


  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  //for (int x = 0; x < kinect2.depthWidth; x++) {
  // for (int y = 0; y < kinect2.depthHeight; y++) {
  //int offset = x + y * kinect2.depthWidth;
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
  fill(150, 0, 255);
  ellipse(avgX, avgY, 64, 64);



  //fill(255);
  //textSize(32);
  //text(minThresh + " " + maxThresh, 10, 64);
  opencv.loadImage(img);
  detectBlobs();
  displayBlobs();
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
    ellipse(r.x+50, r.y+50, 50, 50);
    //
    newBlobs.add(contour);
  }

  return newBlobs;
}