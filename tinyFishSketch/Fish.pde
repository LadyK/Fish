/*
Borrowed from Dan Shiffman's Nature of Code Chapter 6
*/

color shimmer;
float rand;

class Fish {
  PVector location, velocity, acceleration;
  float r, maxforce, maxspeed;

  Fish(PVector l) {
    location = new PVector(l.x, l.y); //, l.z
    acceleration = new PVector (0, 0); //, 0
    velocity = new PVector(random(-1, 1), random(-1, 1)); //, random(-1, 1)
    r = 3.0;
    maxspeed = 2;
    maxforce = 0.09;
  }

  void run(ArrayList<Fish>school, float nV) {
    flock(school);
    update();
    borders();
    display(nV);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void flock(ArrayList<Fish> school) {
    PVector sep = separate(school);
    PVector ali = align(school);
    PVector coh = cohesion(school);
    //arb. weight forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    //add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }


  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
  PVector separate(ArrayList<Fish> school) {
    float desiredseparation = 35.0f; // was 35.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Fish other : school) {
      float d = PVector.dist(location, other.location);
      if ((d >0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count >0) {
      steer.div((float)count);
    }

    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  } // separate

  PVector align(ArrayList<Fish> school) {
    float neighbordist = 60; // was 45
    PVector sum = new PVector(0, 0);
    int count = 0;
    for ( Fish other : school) {
      float d = PVector.dist(location, other.location);
      if (( d > 0) && ( d < neighbordist) ) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }
  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Fish> school){
    float neighbordist = 75;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for(Fish other : school){
      float d = PVector.dist(location, other.location);
      if(( d > 0) && (d < neighbordist)){
        sum.add(other.location);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      return seek(sum);
    } else {
      return new PVector(0, 0);
    }
  }
   void display(float nV_) {

    pushMatrix();
    translate(location.x, location.y);  
    rotateY(nV_);
    fill(shimmer);
    ellipse(0, 0, 30, 30);
    popMatrix();
  }

  
}  // class
