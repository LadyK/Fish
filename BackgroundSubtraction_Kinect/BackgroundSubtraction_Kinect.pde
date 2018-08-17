// 
// Daniel Shiffman's Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original Depth thresholding example by Elie Zananiri
// http://www.silentlycrashing.net

// Background Subtraction using webcam + openCV courtesy:
//https://gist.github.com/newshorts/e0caa9961c8e61f2a007
// This will show background subtraction from your webcam in processing using:
// https://github.com/atduskgreg/opencv-processing


import org.openkinect.freenect.*;
import org.openkinect.processing.*;
// open cv:
import gab.opencv.*;
import java.awt.*;
import processing.video.*;

OpenCV opencv;

Kinect kinect;

// Depth image
PImage depthImg, currentImg, previousImg;

// Which pixels do we care about?
int minDepth =  520;
int maxDepth = 860;

// What is the kinect's angle
float angle;

void setup() {
  size(1280, 960, P2D);


  kinect = new Kinect(this);
  //print("kinect width is:  "); println(kinect.width);
  //print("kinect height is:  "); println(kinect.height);
  kinect.initDepth();
  kinect.initVideo();
  angle = kinect.getTilt();

  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  opencv.startBackgroundSubtraction(5, 3, 0.5); // what do these parameters mean?

  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);

  //currentImg = new PImage(640, 480);
  //previousImg = new PImage(640, 480);
}

void draw() {
  scale(2.0);
  background(0);
  // Draw the raw image
  //image(kinect.getDepthImage(), 0, 0);
  ///*
  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i+=2) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(255);
    } else {
      depthImg.pixels[i] = color(0);
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  //*/
  //image(depthImg, kinect.width, 0);
  image(depthImg, 0, 0); //<-- threshold

  /*
  this just means creating a new image that is (for example) 
   10% the current image and 90% all the previous images.
   */
  /*
  if (frameCount % 5 == 0) {
   //currentImg.copy(depthImg, 0, 0, 640, 480, 0, 0, 640, 480);
   opencv.loadImage(depthImg);
   // opencv.copy(depthImg);
   }
   else{
   background(0);
   }
   */
  //PImage video = kinect.getVideoImage();
  //opencv.loadImage(video);
  opencv.loadImage(depthImg); // send the video to openCV
  //opencv.loadImage(kinect.getDepthImage());
  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(2);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }


  fill(255);
  text("TILT: " + angle, 10, 20);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
}

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  } else if (key == 'a') {
    minDepth = constrain(minDepth+10, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-10, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+10, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-10, minDepth, 2047);
  }
}