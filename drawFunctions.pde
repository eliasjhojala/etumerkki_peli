void createNotesToDrag() {
  for(int i = 0; i < 10; i++) {
    notesToDrag[i*2] = new Note(width-100, height-300, "Alennus");
    notesToDrag[i*2+1] = new Note(width-300, height-300, "Ylennys");
    notesToDrag[i*2].show();
    notesToDrag[i*2+1].show();
  }
}

void resetNoteToDragLocation(Note note) {
  PVector newLocation = new PVector(0, 0);
  if(note.getTypeAsString().equals("Alennus")) {
    newLocation.x = width-100;
    newLocation.y = height-300;
  }
  if(note.getTypeAsString().equals("Ylennys")) {
    newLocation.x = width-300;
    newLocation.y = height-300;
  }
  note.moveTo(newLocation);
}

void drawViivasto(int x, int y, int w, int h) {
  pushMatrix();
  pushStyle();
    stroke(viivastoColor);
    strokeWeight(10);
    for(int i = 0; i < 5; i++) {
      translate(0, 100);
      line(100, 0, 1000, 0);
    }
  popMatrix();
  popStyle();
}
