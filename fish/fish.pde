
//Shape portal = new Shape();
Shape[] shapes = new Shape[30];

void setup() {
  size(displayWidth, displayHeight); 

  background(255);

  for (int i = 0; i < shapes.length-1; i++) {  // loop through the array
    shapes[i] = new Shape();      // make a new object at each indice
  }
}

void draw() {
  background(0);
/*
  for (int i = 0; i < shapes.length-1; i++) {  // loop through the arrray
    shapes[i] = shapes[i+1];    // fill the first spot, with the one to the right
  }
  //portal.display();
  //portal.move();

  //add a new one on the end of the array with new location
  Shape newbie = new Shape();  // make a new shape objecct
  newbie.centerX = mouseX;    // assign mouseX to shape's centerX parameter
  newbie.centerY = mouseY;
  shapes[shapes.length-1] = newbie; // put that new shape in the last spot
*/

  if (mouseX != 0 || mouseY != 0) {  // if the mouse isn't pressed
  
    for (int i = 0; i < shapes.length-1; i++) { // loop through the shapes
      float rand = random(0, 1); // pick a new random value
      Shape temp = shapes[i];  // pull a shape of the array to work with
      // How response to the mouse? this slows the movement
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

  for (int i = 0; i < shapes.length-1; i++) {
    shapes[i].display();
    shapes[i].move();
    
  }
} // draw loop

void mousePressed() {
  //portal.newLoc(mouseX, mouseY);
}