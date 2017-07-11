/*
  transitioned to arraylist
 objects disappear over time
 
 - dbl check array list mgmnt. additions seem oddly spikey
 - slow down last visuals  --> time between mouse moved
 
 - multiples + smaller
 - change color
 - stroke ?
 
 */
//Shape portal = new Shape();
//Shape[] shapes = new Shape[50];
//ArrayList<Shape> shapes = new ArrayList<Shape>();
 ArrayList<Shape> cloudArray = new ArrayList<Shape>();
//long stamp;
//boolean disappear = false;



void setup() {
  size(displayWidth, displayHeight); 
  //size(400, 400);
  background(255);
  for (int i = 0; i < 25; i++) {  // loop through the array
    //shapes[i] = new Shape();      // make a new object at each indice
    cloudArray.add(new Shape(width/2, height/2));
  }
}

void draw() {
  background(0);
  //println(disappear);
  println();
  print("size of shapeCloud: "); 
  println(shapeCloud.size()); //51
  //if (disappear == false){
  //add a new one on the end of the array with new location
  //Shape newbie = new Shape();  // make a new shape objecct
  //newbie.centerX = mouseX;    // assign mouseX to shape's centerX parameter
  //newbie.centerY = mouseY;
  //shapes[shapes.length-1] = newbie; // put that new shape in the last spot

  //println("got here");
  //}


  if (mouseX != 0 || mouseY != 0) {  // if the mouse isn't pressed
    //for (int i = 0; i < shapes.size()-1; i++) { // loop through the shapes
    for (int i = shapeCloud.size()-1; i >= 0; i--) {
      float rand = random(0, 1); // pick a new random value
      //Shape temp = shapes[i];  // pull a shape of the array to work with
      Shape temp = shapeCloud.get(i);
      // this slows the movement
      if (rand < .65) {  
        temp.centerX += (mouseX - temp.centerX) * 0.001;  // assign that shape a new centerX parameter
        temp.centerY += (mouseY - temp.centerY) * 0.001;
      }
      if ( rand >= .65) {
        temp.centerX += (mouseX - temp.centerX) * 0.01; // assign that shape a new centerX
        temp.centerY += (mouseY - temp.centerY) * 0.01;
      }
    } // for-loop of shapes
  } // if the mouse isn't clicked

  for (int i = 0; i < shapeCloud.size()-1; i++) {
  //for (int i = shapes.size()-1; i >= 0; i--) {
    Shape temp = shapeCloud.get(i);
    temp.move();
    temp.display();
    // if (disappear == true) {
    if ( temp.opacity <= 0) {
      shapeCloud.remove(i);
    }
  }

  /*
  if (disappear == false) {
   //for (int i = 0; i < shapes.size()-1; i++) {  // loop through the arrray
   for (int i = shapes.size()-1; i >= 0; i--) {
   //shapes[i] = shapes[i+1];    // fill the first spot, with the one to the right
   if ( i != shapes.size()-1) {
   Shape temp = shapes.get(i+1);
   shapes.add(i, temp);
   }
   }
   }
   */
  /*
  if (millis() - stamp > 6000) {
   println("disappearing ");
   disappear = true;
   }
   */
} // draw loop

void mousePressed() {
  //portal.newLoc(mouseX, mouseY);
  //disappear = false;
}


void mouseMoved() {
  //stamp = millis();

  shapeCloud.add(new Shape(mouseX, mouseY));
  println("added new one");
}