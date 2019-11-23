class Cloud {

  //ArrayList<Shape> shapeCloud; //shapes to form one cloud
  
  int limit;
  int numPts;
  int rad;
  Shape[] shapeCloud;

  Cloud(int mX, int mY) {
    //shapeCloud = new ArrayList<Shape>();
    
    limit = 2;
    Shape[] shapeCloud = new Shape[2];
    numPts = 5; //10
    rad = 25;
    
    // creating #limit shapes and push to cloud array:
    for (int i = 0; i < shapeCloud.length; i++) {
      // pick some points around the mouse for the shape
      int randX = int(random(-20, 20)) + mX; 
      int randY = int(random(-20, 20)) + mY;

      shapeCloud[i]= new Shape(randX, randY, numPts, rad);
      //shapeCloud.add(temp);
    
    }
  } 

  void run() {
    //for (int i = 0; i < shapeCloud.size()-1; i++) {
      for (Shape temp: shapeCloud) { 
      //Shape temp = shapeCloud.get(i);
   //   float op__ = temp.changeOp(); // aging again
      temp.display();
    }
  } // run

  boolean tooOld() {
    boolean dead = false;
    float aveOp = 0;
    for (int i = shapeCloud.length-1; i >= 0; i--) {
      //Shape temp = shapeCloud.get(i);
      Shape temp = shapeCloud[i];
      float op = temp.opacity;
      // let's get the average opacity for the cloud, incl all shapes
      aveOp += op;
       // removing a *shape* from memory since can't see it
       if (aveOp <= limit) {
       //shapeCloud.remove(i);  
       }
    }
    // double check how many shapes we have currently:
    //int currentSize = shapeCloud.size();
    // what's our average opacity, considering how many there were of us:
    float total = aveOp / limit;
    //print("total op for 1 cloud:  ");
    //println(total);
    if (total <= limit) { 
      dead = true; // if alpha of shapes is less than starting #
    } else {
      dead = false;
    }
    total = 0;
    aveOp = 0;
    return dead;
  }

  //kills off a shape, not a cloud; part of a cloud
  void plague() {
   // float whichOne = floor(random(0, shapeCloud.length-1));
    //shapeCloud.remove(whichOne);
    //shapeCloud = shorten(shapeCloud);  //<-- stuck
    println("lost one");
  }
} // end class
