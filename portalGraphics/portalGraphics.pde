 //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
/*

 - multiples + smaller
 - change color
 - stroke ?
 */


Cloud fish;

ArrayList<Cloud> herd; // a bunch of shape groups to make one cloud
boolean trigger;
int lastRecMouseX;
int lastRecMouseY;
int lastMouseX, lastMouseY;
int distDiff= 30; // how much of a difference in mouse location needed
long movedStamp;
boolean portalTrig;
//Portal entry;
ArrayList<Portal> entry;
long portBirth;
PVector lastLoc, currentLoc;
boolean newSpot = false;

//int portalPoints = 18;

void setup() {
  //size(displayWidth, displayHeight); 
  size(300, 800);
  //background(0);

  trigger = false;
  herd = new ArrayList<Cloud>(); 
  portalTrig = false;
  entry = new ArrayList<Portal>();
  /*
  clouds = new ArrayList<Cloud>();
   
   for (int i = 0; i < 10; i++) {  // loop through the array
   //shapes[i] = new Shape();      // make a new object at each indice
   //cloudArray.add(new Shape(width/2, height/2));
   clouds.add(new Cloud());
   }
   */
}

void draw() {
  background(0);
  //fill(0);  // interface
  //rect(0, 0, 300, 800);  // interface

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
      }
      //print("afterwards: ");
      //println(herd.size());
    }
  } //herd runs and checks

  // portal trigger:
  long stamp = millis();
  // if we have been sitting for a bit in one place, but not super long:
  if (((stamp - movedStamp) > 2000) && ((stamp - movedStamp) < 15000) ) {
    triggerPortal();
  } else {
    //portalTrig = false;
  } // if sitting
  print("portBirth: "); 
  println(portBirth);

  // need to be able to have more than one. and to not restart one
  if ((millis() - portBirth < 10000)) {
    // are we on the edges of the screen?
    if (lastMouseX > 10 && lastMouseX < (width - 10) && (lastMouseY > 10 && lastMouseY < (height -10)) ) {
      // if (mouseX < (lastMouseX + distDiff) || mouseX > (lastMouseX - distDiff ) ||
      //   mouseY < (lastMouseY + distDiff) || mouseY > (lastMouseY - distDiff) ) {
      if (newSpot == false) { 
        if (entry.size() > 0) {
          for (int i = entry.size()-1; i >= 0; i--) {
            Portal temp = entry.get(i);
            temp.featureShifter();
            //temp.shift();
            //if (i % 2 == 0) {
            temp.grow();
            //}
            temp.display();
            //temp.move();
            println("display, move");
          }
        } //have portals; run them
      } // same location
    }// not on edges
  } //young

  if ((millis() - portBirth) > 10100 || newSpot == true) {
    // portalTrig = false;
    portBirth = 0;
    println("removing ");
    for (int i = entry.size()-1; i >= 0; i--) {
      entry.remove(i);  // clean out array
    }
  }
  //*/
} // draw loop


void triggerPortal() {
  print("num of portals: ");
  println(entry.size());
  if (entry.size() < 1 && portBirth <= 0) {
    for (int i = 0; i < 5; i++) {
      int randX = 0; //int(random(-5, 5));
      int randY = 0; //int(random(-5, 5));
      Portal temp = new Portal(mouseX + randX, mouseY + randY, 10, 15);
      entry.add(temp);
      //  portalTrig = false;
    }
    portBirth = millis();
  } else {
  };
}

void mousePressed() {

  print("herd is  ");
  println(herd.size());
  print("entry is  ");
  println(entry.size());
}


void mouseMoved() {
  //if we have moved a lot
  if ( ( mouseX > (lastRecMouseX + distDiff)  || mouseX < (lastRecMouseX - distDiff)) ||
    ( mouseY > (lastRecMouseY + distDiff)  || mouseY < (lastRecMouseY - distDiff)) ) {
    fish = new Cloud(mouseX, mouseY);
    herd.add(fish);
    // record locations and time
    lastRecMouseX = mouseX;
    lastRecMouseY = mouseY;
    movedStamp = millis();
    newSpot  = true;
  } else {
    newSpot = false;
    lastMouseX = mouseX;
    lastMouseY = mouseY;
  }
  print("newSpot is:  "); 
  println(newSpot);
}
