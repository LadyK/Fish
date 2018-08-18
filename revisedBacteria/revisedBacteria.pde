ArrayList<Shape> shapeCloud; //shapes to form one cloud

boolean trigger;

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;
PVector v2;
PVector v2_old;

void setup() {
  //size(400, displayHeight); 
  size(640, 520);
  //frameRate(20);
  //size(400, 400);
  background(0);
  int limit = 10;
  trigger = false;
  shapeCloud = new ArrayList<Shape>();

  kinect = new Kinect(this);
  tracker = new KinectTracker();
  v2_old = new PVector(0, 0);
}

void draw() {
  background(0);
  // Run the tracking analysis
  tracker.track();
  // Show the image
  if (keyPressed && key == 32) {
    tracker.display();
  }
  /*
  // Let's draw the raw location
   PVector v1 = tracker.getPos();
   fill(50, 100, 250, 200);
   noStroke();
   ellipse(v1.x, v1.y, 20, 20);
   */
  // Let's draw the "lerped" location
  v2 = tracker.getLerpedPos();
  // debugging tracking:
  // /*  
  fill(100, 250, 50, 200);
  noStroke();
  ellipse(v2.x, v2.y, 20, 20);
  //  */
/*
  if (v2.x != v2_old.x) {
    if (v2.y != v2_old.y) {
      makeNew(v2);
    }
  }
  */
  float d = PVector.dist(v2, v2_old);
  print("distance btwn is:  "); println(d);
  if( d > 2){
   makeNew(v2); 
  }
  v2_old.set(v2.x, v2.y);
  // Display some info
  int t = tracker.getThreshold();
  fill(255);
  text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold", 10, 500);


  //drawClouds();
  if (shapeCloud.size() >= 1) {
    //float aveOp = 0;
    //for (int i = 0; i < shapeCloud.size()-1; i++) {
    for (int i = shapeCloud.size()-1; i >= 0; i--) {
      Shape temp = shapeCloud.get(i);
      float op__ = temp.age();
      temp.display(op__);
      if (op__ <= 0) {
        shapeCloud.remove(i);
        //break;
      }
    }
  }
}

void makeNew(PVector loc) {
  int randX = int(random(-20, 20)) + floor(loc.x);  //mouseX
  int randY = int(random(-20, 20)) + floor(loc.y);  //mouseY

  Shape temp = new Shape(randX, randY);
  shapeCloud.add(temp);
  println("added one");
}

void drawClouds() {
  if (shapeCloud.size() >= 1) {
    //float aveOp = 0;
    //for (int i = 0; i < shapeCloud.size()-1; i++) {
    for (int i = shapeCloud.size()-1; i >= 0; i--) {
      Shape temp = shapeCloud.get(i);
      float op__ = temp.age();
      temp.display(op__);
      if (op__ <= 0) {
        shapeCloud.remove(i);
        //break;
      }

      //temp.move();
      /*
      float op = temp.opacity;
       // let's get the average opacity for the cloud, incl all shapes
       aveOp += op;
      /* 
       if (op <= 0) {
       shapeCloud.remove(i);
       println("removed one");
       }
       */
    }
    /*
    for (int i = 0; i < shapeCloud.size()-1; i++) {
     //for (int i = shapeCloud.size()-1; i >= 0; i--) {
     Shape temp = shapeCloud.get(i);
     float op__ = temp.age();
     
     if (op__ <= 0) {
     shapeCloud.remove(i);
     //break;
     }
     }
     */

    /*
    float total = aveOp / shapeCloud.size();
     print("total op for 1 cloud:  ");
     println(total);
     if (total <= 0) { // ten clouds
     dead = true;
     }
     total = 0;
     aveOp = 0;
     */
  }
}
void mouseMoved() {
  //println("added new one");
  //if (trigger == true) {
  //portal = new Shape(mouseX, mouseY);
  //herd.add(portal);
  //}
  //for (int i = 0; i < limit; i++) {
  // pick some points around the mouse for the shape

  /*
  int randX = int(random(-20, 20)) + mouseX;
   int randY = int(random(-20, 20)) + mouseY;
   
   Shape temp = new Shape(randX, randY);
   shapeCloud.add(temp);
   */
  //}
}

void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}
