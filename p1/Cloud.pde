class Cloud {

  //ArrayList<Shape> shapeCloud; //shapes to form one cloud
  int howMany;
  //int limit;
  // int numPts;
  PVector loc;
  long birth;
  ArrayList<BasicShapeElement>shapes;
  int rando;

  Cloud(PVector newbie) {
    //shapeCloud = new ArrayList<Shape>();
    //loc = newbie.copy();
    loc = new PVector(newbie.x, newbie.y);
    howMany = 40;  // the more the foggier. but need to mind cpu; was 30
    shapes = new ArrayList<BasicShapeElement>(); // not predetermining length
    //numPts = 5; //10
    //rad = 25;
    rando = 100; // was 100
    birth = millis();
    //println(shapes.size());
    // creating #limit shapes and push to cloud array:
    for (int i = 0; i < howMany; i++) {
      // pick some points around the mouse for the shape
      float randX = random((-rando), (rando));
      float randY = random((-rando), (rando));
      BasicShapeElement temp = new BasicShapeElement(int(newbie.x) + randX, int(newbie.y) + randY, 7, radius); 
      shapes.add(0, temp);
    }
    //println("done");
  }  

  void run() {
    for (int i = shapes.size()-1; i >= 0; i--) {
      //for (BasicShapeElement temp : shapes) { 
      BasicShapeElement temp = shapes.get(i);
      boolean dead = temp.update();
      if (dead) {  
        shapes.remove(temp);
      } else { 
        temp.display();
      }// dead
    } // for
  } // run

 Boolean tooclose(PVector l) {
    //Boolean toClose = false;
    float d = dist(loc.x, loc.y, l.x, l.y);
    if ( d < radius * 2) {
      return true;
    } else {
      return false;
    }
    //return toClose;
  }
  
  //kills off a shape, not a cloud; part of a cloud
  void plague() {
    float whichOne = floor(random(0, shapes.size()-1));
    shapes.remove(whichOne);
    //shapeCloud = shorten(shapeCloud);  //<-- stuck
    println("lost one");
  }
} // end class
