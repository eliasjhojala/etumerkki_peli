void setup() {
  //Setup commands here
  { //Set window size to display size (full screen)
    programSize = new PVector(displayWidth, displayHeight);
    size(getX(programSize), getY(programSize));
    frame.setResizable(true);
  } //End of setting window site to display size (full screen)
  storageLocation = new PVector(width-500, height-100); //Location for notes to drag "storage"
  
    //---------------------------------------------------------Setup commands of touchOsc-----------------------------------------------------------
      oscP5 = new OscP5(this, 8000); 
    //----------------------------------------------------------------------------------------------------------------------------------------------
    
  { //Create noteTypes
    int numberOfNoteTypes = 2;
    noteTypes = new NoteType[numberOfNoteTypes];
    noteTypes[0] = new NoteType(0, "media/alennus.png", 60, 190, 0, -50);
    noteTypes[1] = new NoteType(1, "media/ylennys.png", 60, 190, 0, -35);
  } //End of creating noteTypes

  
  String viivastoUrl = "media/viivasto.png"; //Set right path for viivasto file
  
  viivasto = loadImage(viivastoUrl); //Load viivasto image from file
  
  { //Create all the majors
    majors = new Major[numberOfMajors];
    //Syntax: Major(String: name, float[]: ylennykset, float[]: alennukset);
    majors[0] = new Major("C", new float[] { }, new float[] { }); 
    majors[1] = new Major("D", new float[] { 5, 3.5 }, new float[] { });
    majors[2] = new Major("E", new float[] { 5, 3.5, 5.5, 4 }, new float[] { });
    majors[3] = new Major("F", new float[] { }, new float[] { 3 });
    majors[4] = new Major("G", new float[] { 5 }, new float[] { });
    majors[5] = new Major("A", new float[] { 5, 3.5, 5.5 }, new float[] { });
    majors[6] = new Major("H", new float[] { 5, 3.5, 5.5, 4, 2.5 }, new float[] { });
  } //End of creating all the majors
  
  { //Set right places to all the notes according to majors
    for(int i = 0; i < majors.length; i++) {
      int a = 0;
      for(int j = 0; j < majors[i].ylennykset.length; j++) {
        notes[i][a] = new Note(a*50+100, round(majors[i].ylennykset[j]*100)-60, "Ylennys");
        a++;
      }
      for(int j = 0; j < majors[i].alennukset.length; j++) {
        notes[i][a] = new Note(a*50+100, round(majors[i].alennukset[j]*100)-80, "Alennus");
        a++;
      }
    }
  } //End of setting right places to all the notes according to majors
  
  createNotesToDrag(); //And here create the notes which user can drag
}
