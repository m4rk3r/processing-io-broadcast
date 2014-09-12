import processing.net.*;
import processing.serial.*;

Client breeze;
Boolean bound = false;
int mode; /* input=1, output=0 */
PFont myFont;
Serial myPort;

void setup() {
  size(200, 200);
  breeze = new Client(this, "127.0.0.1", 8080);

  myFont = createFont("Georgia", 32);
  textFont(myFont);
  textAlign(CENTER, CENTER);

  println(Serial.list()[4]);
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.clear();
  
  frameRate(20);
}

void draw() {
  background(0);
  
  if (breeze.available() > 0 && !bound) {
    mode = breeze.read();
    println(mode);
    bound = true;
    
    if(mode==1)
      myPort.write('1');
     else
       myPort.write('0');
    
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
    //int data = (int)random(0, 255);
    if(myPort.available() > 0){
      int data = myPort.read();
      breeze.write(data); 
      text("write: "+str(data), width/2, height/2);
    }else{
       text("serial unavail", width/2, height/2); 
    }
  } else if (bound && mode==0) {
    if (breeze.available()>0) { 
      int data = breeze.read();
      if (data==255)bound=false;
      myPort.write(data);
      text("read: "+str(data), width/2, height/2);
    }
  }
}

void disconnectEvent(Client someClient) {
  print("Disconnected");
  bound = false;
}
