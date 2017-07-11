class Cloud{
  
  ArrayList<Shape> shapeCloud = new ArrayList<Shape>();
 
  int limit = 20;
  
  Cloud(){
    
    for(int i = 0; i < limit; i++){
      int randX = int(random(-mouseX, mouseX));
      int randY = int(random(-mouseY, mouseY));
      
      Shape temp = new Shape(randX, randY);
      shapeCloud.add(temp);
      
    }
    
  } 
  
  void run(){
    for(int i = 0; i < limit; i++){
      Shape temp = shapeCloud.get(i);
      temp.display();
      temp.move();
    }
  }
  
 
  
}