class Portal extends Shape{
  
  
  Portal(int x_,int y_, int rings){
    super(x_, y_, rings);
  }
  
   void run() {
    for (int i = 0; i < (the_shape.size()-1); i++) {
      Ring temp = the_shape.get(i);
        temp.portal(mouseX, mouseY);// <-- portals  (formerly newLoc old-style)
      //temp.move(); // <-- shifts towards the mouse. ...eh.
      temp.display();
    }
  }
  
}
  
  
  