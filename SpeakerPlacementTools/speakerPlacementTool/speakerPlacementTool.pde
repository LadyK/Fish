// Tool to assist with sound placement across multi-channel system
//Designed for Luciferins by LadyK Studios

//Grey blocks represent placement of fiber structures
//White circles are speaker placement.
//Mouse over the various blocks (simulating a viewer's movement) to then trigger the corresponding
//speaker in Max. Using the UDP protocols via OSCP5 Library

//Both Max and Processing must be run on sample machine for this to work. Otherwise, change the IP address 
//in line 57 to correspond to the other machine you are trying to communicate with.


import java.util.Map;
import netP5.*;
import oscP5.*; 

IntList inventory;

//OscP5 whereimlistening; // equivalent to [udpreceive] in max, e.g. it's listening
NetAddress whereimsending; // equivalent to [udpsend] in max - it's sending
String messageselector;
OscP5 whereimlistening;

Block b;
//Block[] grid = new Block[60];
ArrayList<Block> grid = new ArrayList<Block>();
int speak;
int blockWidth = 6;
int blockHeight = 10;
//int cols, rows;
int tileCountX = 6;
int tileCountY = 10;
char id;

HashMap<String, Integer> speakerBox = new HashMap<String, Integer>(); //hashmap object for speakers

Map<String, ArrayList<Integer>> panning = new HashMap<String, ArrayList<Integer>>(); // map for panning

HashMap<String, Integer> simpleSpeakers = new HashMap<String, Integer>(); // fiber blocks that control one speaker

void setup() {
  size(800, 800);
  background(127);
  loadHashMap();  //place speakers (one in each white block) and assoicated with respective blocks
  loadMap(); // load blocks that have multiple speakers associated with them
  loadSimpleSpeakers();
  blockWidth = width/tileCountX;              // Calculate # of columns
  blockHeight = height/tileCountY;             // Calculate # of rowsvv
  //scale(8);
  inventory = new IntList();

  whereimsending = new NetAddress("127.0.0.1", 12001); // hostname, port
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  /* start oscP5, listening for incoming messages at port 12000 */
  whereimlistening = new OscP5(this, 12000);

  // create block and add block to grid:
  for (int gridY = 0; gridY < tileCountY; gridY++) {
    for (int gridX = 0; gridX < tileCountX; gridX++) {
      int posx = blockWidth*gridX;
      int posy = blockHeight*gridY;
      PVector l = new PVector(posx, posy); 
      Block b = new Block(l);
      b.identity = 'f'; // make it a fiber to start out with
      b.display();
      grid.add(b);
    }
  }


  // for ( Block b : grid) { 
  for (int i = 0; i < grid.size(); i++) {
    Block b = grid.get(i);
    int s;
    String indice = str(i); // cast to string
    // check hash map for array indice
    if (speakerBox.containsKey(indice)) { // if string is in hashmap, it's as a speaker:
      s = speakerBox.get(indice); //gets the value via key
      b.identity = 's'; // fill box white, it's a speaker
      b.display();
    } else {
      // f = true; // else fill box grey- it's a fiber
      s = 0;
      b.display();
    }
  }
}



void draw() {
  //for (Block b : grid) {
  for (int i = 0; i< grid.size(); i++) {
    Block b = grid.get(i);
    b.display();
    PVector m_ = new PVector(mouseX, mouseY);
    noStroke();
    fill(#FF8959, 100);
    ellipse(mouseX, mouseY, 40, 40);
    // /*
    String indice = str(i); // cast to string
    if (b.rollover(m_) ) { // if the mouse is over this block
      // and this block is a speaker:
      if (b.identity == 's') {
        // println("We are a speaker");
        // check hash map for array indice + send it out:
        if (speakerBox.containsKey(indice)) { // if string is in hashmap, it's as a speaker:
          int speakerNumber = speakerBox.get(indice); // get associated speaker number
          //  print("we are speaker: ");
          println(speakerNumber);
          
          OscMessage myMessage = new OscMessage("max");
          myMessage.add(speakerNumber); /* add an int to the osc message */
          /* send the message */
          whereimlistening.send(myMessage, whereimsending);
          // println(myMessage);
        } //else println();
      } // if we are a speaker */
      else if (panning.containsKey(indice)) {
        //println(panning.get(indice));
        ArrayList<Integer> sps =panning.get(indice);
        OscMessage myMessage = new OscMessage("max");
        myMessage.add(sps.get(0)); /* add an int to the osc message */
        myMessage.add(sps.get(1));
        /* send the message */
        whereimlistening.send(myMessage, whereimsending);
        // println("panning block");
      } else if (simpleSpeakers.containsKey(indice)) { // just one speaker, nearby:
        // println(simpleSpeakers.get(indice));
        int speakerNumber = int(simpleSpeakers.get(indice)); //
        OscMessage myMessage = new OscMessage("max");
        myMessage.add(speakerNumber); /* add an int to the osc message */
        /* send the message */
        whereimlistening.send(myMessage, whereimsending);
        // println("oneSpeaker");
      } else { // we are not over or near a speaker:
        OscMessage myMessage = new OscMessage("max");
        myMessage.add(0); /* add an int to the osc message */
        /* send the message */
        whereimlistening.send(myMessage, whereimsending);
      }
    } // if we are over block
  }// for


  //draw the speakers:

  textSize(32);
  stroke(0);

  fill(255);
  ellipse(393, 77, 100, 100);
  fill(0);
  text("3", 383, 87);

  fill(255);
  ellipse(133, 242, 100, 100);
  fill(0);
  text("1", 123, 252);

  fill(255);
  ellipse(663, 242, 100, 100);
  fill(0);
  text("6", 653, 252);

  fill(255);
  ellipse(392, 398, 100, 100);
  fill(0);
  text("4", 382, 408);

  fill(255);
  ellipse(129, 560, 100, 100);
  fill(0);
  text("2", 119, 570);

  fill(255);
  ellipse(665, 559, 100, 100);
  fill(0);
  text("7", 655, 570);

  fill(255);
  ellipse(399, 721, 100, 100);
  fill(0);
  text("5", 389, 731);
}


void loadMap() { // the panning map, holds the block# and the speaker array that block controls
  ArrayList<Integer> B7 = new ArrayList<Integer>();
  B7.add(1);
  B7.add(2);
  panning.put("7", B7); // box/spot + speakers effected

  ArrayList<Integer> B10 = new ArrayList<Integer>();
  B10.add(2);
  B10.add(3);
  panning.put("10", B10); // box/spot + speakers effected

  ArrayList<Integer> B14 = new ArrayList<Integer>();
  B14.add(1);
  B14.add(2);
  panning.put("14", B14); // box/spot + speakers effected

  ArrayList<Integer> B15 = new ArrayList<Integer>();
  B15.add(2);
  B15.add(3);
  panning.put("15", B15); // box/spot + speakers effected

  ArrayList<Integer> B20 = new ArrayList<Integer>();
  B20.add(1);
  B20.add(6);
  panning.put("20", B20); // box/spot + speakers effected

  ArrayList<Integer> B21 = new ArrayList<Integer>();
  B21.add(6);
  B21.add(3);
  panning.put("21", B21); // box/spot + speakers effected

  ArrayList<Integer> B25 = new ArrayList<Integer>();
  B25.add(1);
  B25.add(6);
  panning.put("25", B25); // box/spot + speakers effected

  ArrayList<Integer> B28 = new ArrayList<Integer>();
  B28.add(6);
  B28.add(3);
  panning.put("28", B28); // box/spot + speakers effected

  ArrayList<Integer> B31 = new ArrayList<Integer>();
  B31.add(6);
  B31.add(7);
  panning.put("31", B31); // box/spot + speakers effected

  ArrayList<Integer> B34 = new ArrayList<Integer>();
  B34.add(6);
  B34.add(4);
  panning.put("34", B34); // box/spot + speakers effected

  ArrayList<Integer> B38 = new ArrayList<Integer>();
  B38.add(2);
  B38.add(4);
  panning.put("38", B38); // box/spot + speakers effected

  ArrayList<Integer> B39 = new ArrayList<Integer>();
  B39.add(7);
  B39.add(4);
  panning.put("39", B39); // box/spot + speakers effected

  ArrayList<Integer> B44 = new ArrayList<Integer>();
  B44.add(2);
  B44.add(5);
  panning.put("44", B44); // box/spot + speakers effected

  ArrayList<Integer> B45 = new ArrayList<Integer>();
  B45.add(7);
  B45.add(5);
  panning.put("45", B45); // box/spot + speakers effected

  ArrayList<Integer> B49 = new ArrayList<Integer>();
  B49.add(2);
  B49.add(5);
  panning.put("49", B49); // box/spot + speakers effected

  ArrayList<Integer> B52 = new ArrayList<Integer>();
  B52.add(7);
  B52.add(5);
  panning.put("52", B52); // box/spot + speakers effected
}

void loadSimpleSpeakers() {
  simpleSpeakers.put("1", 2);
  simpleSpeakers.put("4", 2);
  simpleSpeakers.put("6", 1);
  simpleSpeakers.put("11", 3);
  simpleSpeakers.put("24", 1);
  simpleSpeakers.put("29", 3);
  simpleSpeakers.put("30", 7);
  simpleSpeakers.put("35", 4);
  simpleSpeakers.put("48", 7);
  simpleSpeakers.put("53", 4);
  simpleSpeakers.put("55", 5);
  simpleSpeakers.put("58", 5);
}

void loadHashMap() { // key-value pairs; grid location-associated speaker

  speakerBox.put("2", 2);
  speakerBox.put("3", 2);
  speakerBox.put("8", 2);
  speakerBox.put("9", 2);

  speakerBox.put("12", 1);
  speakerBox.put("13", 1);
  speakerBox.put("18", 1);
  speakerBox.put("19", 1);

  speakerBox.put("16", 3);
  speakerBox.put("17", 3);
  speakerBox.put("22", 3);
  speakerBox.put("23", 3);

  speakerBox.put("26", 6);
  speakerBox.put("27", 6);
  speakerBox.put("32", 6);
  speakerBox.put("33", 6);

  speakerBox.put("36", 7);
  speakerBox.put("37", 7);
  speakerBox.put("42", 7);
  speakerBox.put("43", 7);

  speakerBox.put("40", 4);
  speakerBox.put("41", 4);
  speakerBox.put("46", 4);
  speakerBox.put("47", 4);

  speakerBox.put("50", 5);
  speakerBox.put("51", 5);
  speakerBox.put("56", 5);
  speakerBox.put("57", 5);
}

void mousePressed() {
  // println(mouseX, mouseY);
}
