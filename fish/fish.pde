
//Shape portal = new Shape();
//Shape[] cloud = new Shape[30];
ArrayList<Shape> cloud = new ArrayList<Shape>();
Shape m;
int limit = 10;
PVector[] locs = new PVector[limit];
  

void setup() {
  size(displayWidth, displayHeight); 
  //size(400, 400);

  background(255);

  /*
  for (int i = 0; i < cloud.size()-1; i++) {  // loop through the array
   cloud[i] = new Shape();      // make a new object at each indice
   }
   
   */
  for (int i = 0; i < limit; i++) { //<>//
    //locs[i] = new PVector(random(-20, 20), random(-20, 20)); 
    // float mX = random((mouseX - 50), (mouseX + 50));
    // float mY = random((mouseY - 50), (mouseY + 50));
    // PVector newbie = new PVector(mX, mY);
    float rand_scale = random(10, 30);
    PVector newbie =  PVector.random2D(); //<>//
    newbie.mult(rand_scale); //<>//
    locs[i] = newbie; //<>//
  }
}

void draw() {
  background(0);
  /*
  m = new Shape(mouseX, mouseY, 20);
   m.run();
   cloud.add(m);
   */
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

  /*
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
   
   */

  Shape newbie;
  //int r = 10;
  float theta = 0;
  // many around the mouse, fade away
  for (int i = 0; i < limit; i++) {
    int randy = int(random(5, 10)); // how many rings?
    newbie = new Shape(int(locs[i].x), int(locs[i].y), randy);
    
    int rand_r = int(random(10, 20)); // random radius from mouseX
    float dx = (rand_r * cos(theta)); // + mouseX;
    dx = dx + random(0, 0.05)*dx + random(-20, 20);
    float dy = rand_r * sin(theta);  // + mouseY;
    dy = dy + random(0, 0.05)*dx + random(-20, 20);
    PVector temp = new PVector(dx, dy);
    locs[i] = temp.add(locs[i]);
    theta += 0.2;
    //println(theta);
    
    
    
    
    // want it to be a radius around the mouse, esp direction moving
    /*
    int dx = mouseX - int(locs[i].x);
    int dy = mouseY - int(locs[i].y);
    locs[i].x = locs[i].x + random(0, 0.05)*dx + random(-20, 20);
    locs[i].y = locs[i].y + random(0, 0.05)*dy + random(-20, 20);

    if (locs[i].x > width) locs[i].x = 0;
    if (locs[i].y > height) locs[i].y = 0;
    if (locs[i].x < 0) locs[i].x = width;
    if (locs[i].y < 0) locs[i].y = height;
    */
    
    newbie.run();
    cloud.add(newbie);
  }





  //for (Shape temp : cloud) {
  //for (int i = 0; i < cloud.size()-1; i++) {
  for (int i = cloud.size()-1; i >= 0; i--) {
    Shape temp = cloud.get(i);
    // temp.check();
    temp.run();
    //temp.interaction();
  }

  if (cloud.size() >= 1) {  // if there is more than 2 shapes
    for (int i = cloud.size()-1; i >= 0; i--) {
      Shape temp = cloud.get(i);
      temp.check();
      if (temp.dead == true) {
        cloud.remove(i);
      }
    }
  }
} // draw loop


///*
void mouseMoved() {
  //portal.newLoc(mouseX, mouseY);
  //int rand = int(random(10, 30));
  //cloud.add(new Shape(mouseX, mouseY, rand));
}
//*/