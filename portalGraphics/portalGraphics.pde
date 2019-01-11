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

void setup() {
  size(displayWidth, displayHeight); 
  //size(400, 400);
  background(0);
  trigger = false;
  herd = new ArrayList<Cloud>(); 

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

  if (herd.size() >= 1) {
    for (int i = herd.size()-1; i >= 0; i--) {
      Cloud temp = herd.get(i);
      temp.run();
      // temp.tooOld();   // check if opacity is zero and remove
      if (temp.tooOld()) {
        herd.remove(i);  // remove a shape cloud kernel from the cloud mass
      }
    }
 
    /*
    // randomly kill off a few _shapes_ from within the cloud herd
    //if (herd.size() >= 1) {
    if (frameCount % 8 == 0) {
      for (int i = 10; i < 0; i-=2) {
        int rando = floor(random(0, herd.size()-1));
        Cloud temp = herd.get(rando);
        temp.plague();
        //^^ || vv is more effective?
        //float whichOne = abs(random(1, herd.size()));
        //herd.remove(whichOne);
      }
      print("afterwards: ");
      println(herd.size());
    } */
  } //herd runs and checks

} // draw loop

void mousePressed() {

  print("herd is  ");
  println(herd.size());
}


void mouseMoved() {

  portal = new Cloud(mouseX, mouseY);
  herd.add(portal);
}
