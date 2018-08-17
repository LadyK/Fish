ArrayList<Shape> shapeCloud; //shapes to form one cloud

boolean trigger;

void setup() {
  size(400, displayHeight); 
  frameRate(20);
  //size(400, 400);
  background(0);
  int limit = 10;
  trigger = false;
  shapeCloud = new ArrayList<Shape>();
}

void draw() {
  background(0);
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
  int randX = int(random(-20, 20)) + mouseX; 
  int randY = int(random(-20, 20)) + mouseY;

  Shape temp = new Shape(randX, randY);
  shapeCloud.add(temp);
  //}

  /*
  avoiding the snake like effect:
   
   if the mouse hasn't moved too much, longer time in one spot
   lives longer
   
   if the mouse is still within 10 +/- pixels, longer
   
   length of time in spot == glow rate/ opacity
   */
}
