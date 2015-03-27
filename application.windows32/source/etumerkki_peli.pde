void draw() {
  //Infinite loop until program end
  background(bgColor); //Clear screen in every loop
  translate(getX(offset), getY(offset));
  doScale();
  
  
  if(gameStarted && countPoints() >= 0) {
    if(!allMajorsCompleted) runGame(); //Run game if it's not completed yet
    else congratulations(); //If completed then show congratulations text
  }
  else if(countPoints() < 0) {
    gameOver(); //Write game over text
  }
  else {
    gameStartMillis = millis();
    gameStarted = true;
  }
  
}

void gameOver() {
  bgColor = color(255, 0, 0);
  textSize(200);
  textAlign(CENTER);
  fill(invert(bgColor));
  text("GAME OVER", width/2, height/2);
}

void congratulations() {
  if(!finalPointsCounted) {
    finalPoints = round(countPoints());
    finalPointsCounted = true;
  }
  textSize(50);
  textAlign(CENTER);
  fill(invert(bgColor));
  text("Congratulations! You completed the game and got " + str(finalPoints) + "/10 points", width/2, height/2);
  if(!gameCompleteTimeCounted) {
    completeTime = millis()-gameStartMillis;
    gameCompleteTimeCounted = true;
  }
}

color invert(color c) {
  return color(255-red(c), 255-green(c), 255-blue(c));
}

void changeMajor(int direction) {
  if(direction == UP) { actualMajor++; } else if(direction == DOWN) { actualMajor--; }
  if(actualMajor >= majors.length) {
    allMajorsCompleted = true;
  }
  actualMajor = constrain(actualMajor, 0, majors.length-1);
  createNotesToDrag();
}

void mouseDragged() {
  mouseIsDragged = true;
}
void mousePressed() {
  mouseIsDragged = true;
}
void mouseReleased() {
  mouseIsDragged = false;
}

