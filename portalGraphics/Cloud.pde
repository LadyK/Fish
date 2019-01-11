class Cloud {

  ArrayList<Shape> shapeCloud; //shapes to form one cloud

  int limit = 5;

  Cloud(int mX, int mY) {
    shapeCloud = new ArrayList<Shape>();
    
    // creating #limit shapes and push to cloud array:
    for (int i = 0; i < limit; i++) {
      // pick some points around the mouse for the shape
      int randX = int(random(-20, 20)) + mX; 
      int randY = int(random(-20, 20)) + mY;

      Shape temp = new Shape(randX, randY);
      shapeCloud.add(temp);
    }
  } 

  void run() {
    for (int i = 0; i < shapeCloud.size()-1; i++) {
      Shape temp = shapeCloud.get(i);
   //   float op__ = temp.changeOp(); // aging again
      temp.display();
    }
  } // run

  boolean tooOld() {
    boolean dead = false;
    float aveOp = 0;
    for (int i = shapeCloud.size()-1; i >= 0; i--) {
      Shape temp = shapeCloud.get(i);
      float op = temp.opacity;
      // let's get the average opacity for the cloud, incl all shapes
      aveOp += op;
      ///* 
       if (op <= 0) {
       shapeCloud.remove(i);  // removing a shape from memory since can't see it
       println("removed one");
       }
      //*/
    }
    // double check how many shapes we have currently:
    //int currentSize = shapeCloud.size();
    // what's our average opacity, considering how many there were of us:
    float total = aveOp / limit;
    print("total op for 1 cloud:  ");
    println(total);
    if (total <= 0) { 
      dead = true;
    } else {
      dead = false;
    }
    total = 0;
    aveOp = 0;
    return dead;
  }

  //kills off a shape, not a cloud; part of a cloud
  void plague() {
    float whichOne = floor(random(0, shapeCloud.size()-1));
    shapeCloud.remove(whichOne);
    println("lost one");
  }
} // end class
