void runGame() { 
  drawViivasto();
  showMajorName();
  
  setMouseLocations();
  doDragging();
  checkIfRight();
  drawToDrag();
}

void doScale() {
  scale(zoom);
}

void drawViivasto() {
  drawViivasto(100, 300, 1000, 400);
}

void showMajorName() {
  //Show current major name
  pushStyle();
    stroke(textColor);
    fill(textColor);
    textSize(50);
    text(majors[constrain(actualMajor, 0, majors.length-1)].name, 50, 50);
  popStyle();
  //End of showing current major name
}

void setMouseLocations() {
  mouseLocation = new PVector(mouseX-getX(offset), mouseY-getY(offset)); //Save mouse location to PVector
  mouseOldLocation = new PVector(pmouseX-getX(offset), pmouseY-getY(offset));
  mouseLocation.div(zoom);
  mouseOldLocation.div(zoom);
}

void doDragging() {
  { //Dragging
     movingObjects = false;
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
          
          
          boolean noteIsAlreadySelected = note.selected;
          boolean nothingSelected = firstSelected == -1;
          boolean thisSelected = firstSelected == i;
          boolean noOthersSelected = nothingSelected || thisSelected;
          boolean notAlreadyFound = !note.found;
          boolean mouseOverNote = vectorsAreOnTopOfEachOthers(mouseLocation, note.location, note.getImgSizeFast());
          boolean clickedNote = mouseOverNote && mousePressed && nothingSelected;
  
          //Check if we want to move note
          if(((clickedNote || noteIsAlreadySelected) && noOthersSelected) && notAlreadyFound) {
            note.locationOffset(mouseLocation, mouseOldLocation);
            note.selected = true;
            
            if(nothingSelected) {
              firstSelected = i;
            }
          } //End of: Check if we want to move note
          
          if(!mousePressed) {
            note.selected = false;
            firstSelected = -1;
          }
          note.checkMoving();
        }
      }
      if(handCursor) { cursor(HAND); }
      else { cursor(ARROW); }
    } //End of checking notesToDrag array isn't null
  } //End of dragging
}

void checkIfRight() {
  { //CHECK IF DRAGGED TO RIGHT PLACE --> IF ALL DRAGGED TO RIGHT PLACE CHANGE MAJOR
    if(notes != null) { //Check that notes object array isn't null
      for(int i = 0; i < notes.length; i++) { //Go through all the note objects
        if(actualMajor == i) {
          Note[] actualNotes = notes[i];
          boolean thisMajorIsCompleted = true;
          if(actualNotes != null) {
            for(int j = 0; j < actualNotes.length; j++) {
              Note note = actualNotes[j];
              if(note != null) { //Check that note object isn't null
                
                if(!note.found) { //Check if note is not "found" already
                  thisMajorIsCompleted = false;
                  { //Check if some note is dragged to right place
                    boolean draggedToRightPlace = false; //By default nothing is in right place
                    if(notesToDrag != null) { //Check that notesToDrag array isn't null
                      for(int k = 0; k < notesToDrag.length; k++) { //Go through all the notesToDrag
                      Note toDrag = notesToDrag[k];
                        if(notesToDrag[k] != null) { //Check that single notesToDrag object isn't null
                          if(vectorCentersAreOnTopOfEachOthers(toDrag.location, note.location, note.getImgSizeFast()) && !mousePressed && toDrag.type == note.type && !note.found) {
                            //What to do if dragged (near) to right place
                            draggedToRightPlace = true; //Tell that there are notes dragged to right place
                            toDrag.moveTo(note.location);
                            toDrag.thisColor = color(0, 255, 0); //Set green color to tell that's right place
                            note.found = true; //Never move this note anymore
                            toDrag.found = true; //Never move this note anymore
                            //End of what to do if dragged (near) to right place
                          }
                        } //End of checking that single notesToDrag object isn't null
                      } //End of going through all the notesToDrag
                    } //End of checking that notesToDrag array isn't null
                    if(draggedToRightPlace) { 
                      //What to do if dragged to right place
                    }
                  } //End of checkin are there any notes dragged to right place
                  
                } //End of checking if note is not "found" anymore
                
                note.draw();
                
                
              } //End of checking single note object isn't null
            } //End of going through actualNotes (notes in current major)
          } //End of checking actualNotes object array isn't null
          if(thisMajorIsCompleted && !movingObjects) {
            changeMajor(UP);
          }
        } //End of if(actualMajor == i)
      } //End of for(int i = 0; i < notes.length; i++)
    } //End of if(notes != null)
  } //END OF CHECKING IF DRAGGED TO RIGHT PLACE ETC.
}

void drawToDrag() {
  { //Draw notes to drag
    Note[] actualNotes = notesToDrag;
    for(int j = 0; j < actualNotes.length; j++) {
      Note note = actualNotes[j];
      if(note != null) { //Check that note object isn't null
        note.draw();
      } //End of checking that note object isn't null
    }
  } //End of drawing notes to drag
}
