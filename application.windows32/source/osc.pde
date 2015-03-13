

void oscEvent(OscMessage theOscMessage) {
  String addr = theOscMessage.addrPattern(); //Luetaan touchOSCin elementin osoite
  int val = round(theOscMessage.get(0).floatValue()); //Luetaan touchOSCin elementin arvo
  
  for(int i = 1; i <= 12; i++) { //Käydään kaikki touchOSCin kanavat (faderit) läpi
    String nimi = "/1/fader" + str(i);
    if(addr.equals(nimi)) {
      if(i == 1) {
        bgColor = color(val, green(bgColor), blue(bgColor));
      }
      if(i == 2) {
        bgColor = color(red(bgColor), val, blue(bgColor));
      }
      if(i == 3) {
        bgColor = color(red(bgColor), green(bgColor), val);
      }
      if(i == 4) {
        noteColor = color(val, green(noteColor), blue(noteColor));
      }
      if(i == 5) {
        noteColor = color(red(noteColor), val, blue(noteColor));
      }
      if(i == 6) {
        noteColor = color(red(noteColor), green(noteColor), val);
      }
      if(i == 7) {
        viivastoColor = color(val, green(viivastoColor), blue(viivastoColor));
      }
      if(i == 8) {
        viivastoColor = color(red(viivastoColor), val, blue(viivastoColor));
      }
      if(i == 9) {
        viivastoColor = color(red(viivastoColor), green(viivastoColor), val);
      }
    }
  }
  
  println("RECEIVED");
}
