class Portal {

  ArrayList<Ring> the_portal;  // this could be an array. length set by num_r
  int ticker;
  boolean dead;
  int rad;

  Portal(int x_, int y_, int rings, int rad_) {
    dead = false;
    ticker = 0;
    rad = rad_;
    //the_shape = new Ring[30];
    the_portal = new ArrayList<Ring>();

    //for (int i = 0; i < num_r; i++) {  // loop through the array
    for (int i = rings; i >= 0; i--) {  
      //the_shape[i] = new Ring(x_, y_);      // make a new object at each indice

      the_portal.add(new Ring(x_, y_, rad, 2)); //10 - 125  /* size 10, with 5 shapes, is cool effect */
    }
  }

  void run() {
    int span = 3;
    for (int i = 0; i < (the_portal.size()-1); i++) {
      Ring temp = the_portal.get(i);
      //temp.portal(mouseX, mouseY, (i+6));// <-- portals  (formerly newLoc old-style)
     
      temp.portalGrowth(span);
      //temp.move(); // <-- shifts towards the mouse. ...eh.

      temp.display();
      ///*
      if(span < 20) span++;  //span+=3;
      else if(span >= 25) span = 1;
      //*/
    }
  } // run


  void check() {
    for (int i = the_portal.size()-1; i >= 0; i--) {
      //for (int i = 0; i <= the_shape.size()-1; i++) {
      Ring temp = the_portal.get(i);
      // if they are younger than 30
      if (temp.age <= 30) { //&&(temp.age >= 2) )
      //temp.opacity--;
      temp.opacity = temp.opacity - 0.5;
      }
      
      // if they are older than thrity 
       else if (temp.age > 30)  {
       
        temp.opacity = temp.opacity - 0.5;
      }
        
       

      // if a particular ring is faded away, remove it and age us
      if (temp.opacity <= 0.0) {
        the_portal.remove(i);
        ticker++;   //we've aged
      }

      // if we are older than we have rings, we are dead
      if (ticker >= the_portal.size()) {
        dead = true;
      }
    } // for
  } // check
  
  
} // portal