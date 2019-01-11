import controlP5.*;

//ControlP5 cp5;
//int sliderValue = 100;

/*
 objects disappear over time
 
 - dbl check array list mgmnt. additions seem oddly spikey
 - slow down last visuals  --> time between mouse moved
 
 - multiples + smaller
 - change color
 - stroke ?
 */


Cloud portal;

ArrayList<Cloud> herd; // a bunch of shape groups to make one cloud
boolean trigger;
int lastMouseX;
int lastMouseY;
int distDiff= 10; // how much of a difference in mouse location needed
long movedStamp;
boolean portalTrig;

void setup() {
  //size(displayWidth, displayHeight); 
  size(300, 800);
  //background(0);
  //cp5 = new ControlP5(this); // interface
  //fill(0);  // interface
  // rect(0, 0, 300, 800);  // interface
  /*
    cp5.addSlider("slider")
   .setPosition(325,10)
   .setSize(200,20)
   .setRange(0,200)
   .setValue(128)
   ;
   
   */

  trigger = false;
  herd = new ArrayList<Cloud>(); 
  portalTrig = false;
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
  if (millis() - movedStamp > 2000) {
    ellipseMode(CENTER);
    fill(255, 0, 0);
    ellipse(mouseX, mouseY, 10, 10);
    portalTrig = true;
  }
} // draw loop

void mousePressed() {

  print("herd is  ");
  println(herd.size());
}


void mouseMoved() {
  //if (mouseX < 250 ) { //interface
  if ( ( mouseX > (lastMouseX + distDiff)  || mouseX < (lastMouseX - distDiff)) ||
    ( mouseY > (lastMouseY + distDiff)  || mouseY < (lastMouseY - distDiff)) ) {
    portal = new Cloud(mouseX, mouseY);
    herd.add(portal);
    lastMouseX = mouseX;
    lastMouseY = mouseY;
    movedStamp = millis();
  } else {
    // } //interface
  }
}
