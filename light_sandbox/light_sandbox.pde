float con;

void setup(){
  size(800, 800, P3D);
  background(255);
  //background(37, 94, 250, 100);
  con = 0;
  smooth();
}


void draw(){
  background(255);
  con = map(mouseX, 0, 800, 1, 1000);
  float angle = map(mouseX, 0, width, PI/8, PI/2);
  print("angle is: "); print(angle);
   float concentration = map(mouseY, 0, height, 20,1);
    print("con is: "); println(concentration);
    println();
  spotLight(250, 234, 154, 100, height/2, 400, 0, 0, -1, angle, concentration ); // concentration was 5
 //spotLight(250, 234, 154, 100, height/2, 400, 0, 0, -1, PI/2,5 ); 
 // directionalLight(250, 234, 154, 0, 0, -1);
  //directionalLight(255, 255, 255, 0, 0, -1);
  translate(20, 50);
  //if(mousePressed) lights();
  noStroke();
  fill(37, 94, 250, 100);
  beginShape();
  vertex(50, 450);
  vertex(250, 480);
  vertex(175, 50);
  vertex(80, 50);
  endShape();
  
  //noLoop();
  
  
  println(con);
  
}
