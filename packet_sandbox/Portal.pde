class Portal {

  ArrayList<Screen> textBuffers;
  int numScreens;
  int currentLineNum;
  int howManyLines;
  int linesPerScreen;
  String[] inputText;
  int screenLine = 0;
  int yScreen;
  //   linesPerScreen = 9;
  int nextStart = 0;
  color t;
  PFont f;
 

  Portal(PVector l) {
    inputText = loadStrings("packets.txt"); //<>//
    howManyLines = inputText.length;
    numScreens = ceil(howManyLines/10);
    textBuffers = new ArrayList<Screen>();
    currentLineNum = 0;
    linesPerScreen = 9;
    f = createFont("Arial", 12);
    textFont(f, 24);
    textAlign(LEFT);
     //fill(t, topacity);
     topacity = 80;
    yScreen = 420; // ***needs modification
    int nextStart = 0;
    for (int i = 0; i <numScreens; i++) {
      Screen s = new Screen(l, nextStart); //** this is going to need the portal location + some y to it //<>//
      print("l is: "); println(l);
      print("nextStart is: "); println(nextStart);
      nextStart = s.initalize(linesPerScreen, inputText); //<>//
      l.y = l.y + (10 * 10.9); // each LINE plus some space; was * 22; need to tweak if scale changes
      textBuffers.add(s);
    }
  }

  void run() {
    for (Screen s : textBuffers) {
      s.run();
    }

    for (int i = textBuffers.size()-1; i >=0; i--) {
      Screen s = textBuffers.get(i);
      if ((s.screen_location.y + (10 * 10.9)) < 0) { // play with this value if scale more (was 10 * 22)
        textBuffers.remove(i);
      }
    }
  }
}
