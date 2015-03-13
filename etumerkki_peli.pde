void draw() {
  //Infinite loop until program end
  background(bgColor); //Clear screen in every loop
  translate(getX(offset), getY(offset));
  doScale();
  
  if(!allMajorsCompleted) runGame(); //Run game if it's not completed yet
  else congratulations(); //If completed then show congratulations text
  
}

void congratulations() {
  textSize(50);
  textAlign(CENTER);
  fill(invert(bgColor));
  text("Congratulations! You have completed the game", width/2, height/2);
}

color invert(color c) {
  return color(255-red(c), 255-green(c), 255-blue(c));
}

void keyReleased() {
  if(keyCode == UP || keyCode == DOWN) {
    changeMajor(keyCode);
  }
  println(actualMajor);
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
//  if(firstSelected == -1) {
//    offset.x -= pmouseX-mouseX;
//    offset.y -= pmouseY-mouseY;
//  }
  mouseIsDragged = true;
}
void mousePressed() {
  mouseIsDragged = true;
}
void mouseReleased() {
  mouseIsDragged = false;
}

