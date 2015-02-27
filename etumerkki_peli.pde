void draw() {
  //Infinite loop until program end
  background(bgColor); //Clear screen in every loop
  translate(getX(offset), getY(offset));
  drawViivasto(100, 300, 1000, 400);
  pushStyle();
    stroke(textColor);
    fill(textColor);
    textSize(50);
    text(majors[constrain(actualMajor, 0, majors.length-1)].name, 50, 50);
  popStyle();
  mouseLocation = new PVector(mouseX-getX(offset), mouseY-getY(offset)); //Save mouse location to PVector
  mouseOldLocation = new PVector(pmouseX-getX(offset), pmouseY-getY(offset));
  if(mousePressed) {
    rectLocation = mouseLocation.get(); //Copy mouseLocation to rectLocation
  }
  
  
  
  
  if(notes != null) { //Check that notes object array isn't null
    for(int i = 0; i < notes.length; i++) { //Go through all the note objects
      if(actualMajor == i) {
        Note[] actualNotes = notes[i];
        if(actualNotes != null) {
          for(int j = 0; j < actualNotes.length; j++) {
            Note note = actualNotes[j];
            if(note != null) { //Check that note object isn't null
              
              { //Check if some note is dragged to right place
                boolean draggedToRightPlace = false;
                if(notesToDrag != null) { //Check that notesToDrag array isn't null
                  for(int k = 0; k < notesToDrag.length; k++) { //Go through all the notesToDrag
                    if(notesToDrag[k] != null) { //Check that single notesToDrag object isn't null
                      if(vectorCentersAreOnTopOfEachOthers(notesToDrag[k].location, note.location, note.getImgSizeFast()) && !mousePressed && notesToDrag[k].type == note.type) {
                        draggedToRightPlace = true;
                        notesToDrag[k].moveTo(note.location);
                        notesToDrag[k].thisColor = color(0, 255, 0);
                      }
                    } //End of checking that single notesToDrag object isn't null
                  } //End of going through all the notesToDrag
                } //End of checking that notesToDrag array isn't null
                if(draggedToRightPlace) { /*note.show();*/ }
              } //End of checkin are there any notes dragged to right place
              
              if(((vectorsAreOnTopOfEachOthers(mouseLocation, note.location, note.getImgSizeFast()) && mousePressed && firstSelected == -1) || note.selected) && (firstSelected == -1 || firstSelected == i)) { //Check if mouse is about in the same place where the note object is
                note.locationOffset(mouseLocation, mouseOldLocation);
                note.selected = true;
                if(firstSelected == -1) {
                  firstSelected = i;
                }
              }
              if(!mousePressed) {
                note.selected = false;
                firstSelected = -1;
              }
              note.draw();
            }
          }
        }
      }
    }
  }
  
  if(notesToDrag != null) { //Check that notesToDrag array is not null
    Note[] actualNotes = notesToDrag;
    boolean handCursor = false;
    for(int j = 0; j < actualNotes.length; j++) {
      int i = j + 100;
      Note note = actualNotes[j];
      if(note != null) { //Check that note object isn't null
        if(((vectorsAreOnTopOfEachOthers(mouseLocation, note.location, note.getImgSizeFast())))) {
          handCursor = true;
        }

        if(((vectorsAreOnTopOfEachOthers(mouseLocation, note.location, note.getImgSizeFast()) && mousePressed && firstSelected == -1) || note.selected) && (firstSelected == -1 || firstSelected == i)) { //Check if mouse is about in the same place where the note object is
          note.locationOffset(mouseLocation, mouseOldLocation);
          note.selected = true;
          
          if(firstSelected == -1) {
            firstSelected = i;
          }
        }
        if(!mousePressed) {
          note.selected = false;
          firstSelected = -1;
        }
        note.draw();
      }
    }
    if(handCursor) {
      cursor(HAND);
    }
    else {
      cursor(ARROW);
    }
  }
  
}

void keyReleased() {
  if(keyCode == UP || keyCode == DOWN) {
    changeMajor(keyCode);
  }
  println(actualMajor);
}

void changeMajor(int direction) {
  if(direction == UP) { actualMajor++; } else if(direction == DOWN) { actualMajor--; }
  actualMajor = constrain(actualMajor, 0, majors.length-1);
  createNotesToDrag();
}

void mouseDragged() {
  if(firstSelected == -1) {
    offset.x -= pmouseX-mouseX;
    offset.y -= pmouseY-mouseY;
  }
  mouseIsDragged = true;
}
void mousePressed() {
  mouseIsDragged = true;
}
void mouseReleased() {
  mouseIsDragged = false;
}

