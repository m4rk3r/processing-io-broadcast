import processing.net.*;

Client breeze;
Boolean bound = false;
int mode; /* input=1, output=0 */
PFont myFont;

void setup() {
  size(200, 200);
  breeze = new Client(this, "127.0.0.1", 8080);

  myFont = createFont("Georgia", 32);
  textFont(myFont);
  textAlign(CENTER, CENTER);

  frameRate(10);
}

void draw() {
  background(0);
  
  if (breeze.available() > 0 && !bound) {
    mode = breeze.read();
    println(mode);
    bound = true;
  }else if(!bound){
   text("unbound", width/2, height/2); 
  }

  if (bound && mode==1) {
    if (breeze.available()>0) {
      int data = breeze.read();
      if (data==255) {
        bound = false;
      }
    }
    int data = (int)random(0, 255);
    breeze.write(data); 
    text("write: "+str(data), width/2, height/2);
  } else if (bound && mode==0) {
    if (breeze.available()>0) { 
      int data = breeze.read();
      if (data==255)bound=false;
      text("read: "+str(data), width/2, height/2);
    }
  }
}
