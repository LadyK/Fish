class Cloud {

  //ArrayList<Shape> shapeCloud; //shapes to form one cloud

  int howMany;
  //int numPts;
  //int rad;
  PVector loc;
  long birth;
  ArrayList<BasicShapeElement>shapes;
  int rando;
 
  Cloud(PVector newbie) {
    //shapeCloud = new ArrayList<Shape>();
    loc = newbie.copy();
    howMany = 15;  // the more the foggier. but need to mind cpu
    shapes = new ArrayList<BasicShapeElement>(); // not predetermining length
    //numPts = 5; //10
    //rad = 25;
    rando = 100;
    birth = millis();
    println(shapes.size());
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
      //temp.featureShifter(); // might save processor to not call so often
      //int rand_c = int(random(1, 300));
      //color c_ = colorChanger();
      //shape.shrink();
      boolean dead = temp.update();
      if (dead) {  
        shapes.remove(temp);  
        println("removed one");  // displaying rest, until loop is restored
      } else {
          temp.display();
      }// dead
    } // for
  } // run



  //kills off a shape, not a cloud; part of a cloud
  void plague() {
     float whichOne = floor(random(0, shapes.size()-1));
     shapes.remove(whichOne);
    //shapeCloud = shorten(shapeCloud);  //<-- stuck
    println("lost one");
  }
} // end class
