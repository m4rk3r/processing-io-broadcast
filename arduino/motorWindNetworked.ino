
int reading = 0;
float avg = 0.0f;
float _max = 5;

int motorMax = 254;
int motorMin = 155;

boolean bound = false;
boolean mode; /*  1 = breeze, 0 = sensor */

void setup(){
  pinMode(9,OUTPUT); 

  Serial.begin(9600);
}

void loop(){

  if(bound){
    if(mode){
      reading = analogRead(0);
      avg = (avg * 2 + reading)/3;

      _max = max(_max,avg);

      if(round(avg) > 1){
        int value = map(round(avg),1,round(_max),motorMin,motorMax);
        Serial.write(value);
      }else{
        Serial.write(0);
      }
    }else if(!mode){
      byte incoming = Serial.read();
      analogWrite(9,incoming);
    }
  }else{

    if(Serial.available()>0){
      char val = Serial.read();
      mode = (boolean)(val == '1');
      bound = true;
    }
  }

  delay(50);
}

