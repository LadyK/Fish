
    /*    
     //    print("mode is: ");
     //    println(mode);
     if (mode == 0) { // coming to maturity
     if (frameCount % 5 == 0) {
     float r_ = random(1);
     if (r_ < .9) {
     opacity +=1;
     opacity = constrain(opacity, 4, op_limit);
     if (opacity == op_limit) {
     mode = 1;
     increment = int(random(1000, 1800));
     mature = millis(); // reset
     op_limit = op_limit - howM;  // take off a section from the limit, to lower the max; thus not as bright
     } // if opp limit
     } //random
     } // %
     } // mode 0
     
     if (mode == 1) { // decreasing
     if (frameCount % 5 == 0) {
     // initial decrease:
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .7) {
     opacity +=2;
     } else {
     opacity--;
     }
     opacity = constrain(opacity, 4, op_limit);
     } // initial decrease
     else {
     mode = 2;
     increment = int(random(1800, 3000));
     mature = millis();
     op_limit = op_limit - howM;
     }
     } // frameCount
     } // mode 1
     
     if (mode == 2) {
     if (frameCount % 5 == 0) {
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .8) {
     opacity +=4;
     } else {
     opacity -=2;
     }
     opacity = constrain(opacity, 4, op_limit);
     } // nxt increment
     else {
     mode = 3;
     mature = millis();
     increment = int(random(1800, 3000));
     op_limit = op_limit - howM;
     }
     } //if frameCount
     } //mode 2
     
     if (mode == 3) {
     
     if (frameCount % 5 == 0) {
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .7) {
     opacity +=6;
     } else {
     opacity -=2;
     }
     opacity = constrain(opacity, 4, op_limit);
     } // nxt increment
     else {
     mode = 4;
     mature = millis();
     increment = int(random(1800, 3000));
     op_limit = op_limit - howM;
     } //else
     } //framecount
     }// mode 3
     
     if (mode == 4) {
     if (frameCount % 5 == 0) {
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .5) {
     opacity--;
     } else {
     opacity +=4;
     }
     //           opacity = constrain(opacity, 4, op_limit);
     } //increment
     else {
     opacity--;
     }
     } //framecount
     } //mode 4
     */
