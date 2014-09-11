import processing.net.*;

Server server;

/* temp bin to store unpaired clients */
ArrayList<Client> clients;
ArrayList<Group> groups;
PFont font;

class Group {
  public Client a;
  public Client b;
  Boolean alive;

  Group (Client _a, Client _b) {
    println("New grouping: a:"+_a.ip() +" -> "+_b.ip());
    a = _a;
    b = _b;

    a.write(1);
    b.write(0);
    alive = true;
  }

  void broadcast() {
    if (a.available() > 0 && alive) { 
      int data = a.read();
      b.write(data);
    }
  }
}


void setup() {
  size(200, 200);
  server = new Server(this, 8080);

  clients = new ArrayList<Client>();
  groups  = new ArrayList<Group>();

  frameRate(50);
  font = createFont("Georgia", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
}

void draw() {
  if (clients.size() > 1) {
    Group g = new Group(clients.get(0), clients.get(1));
    groups.add(g);

    /* dumb */
    clients.remove(0);
    clients.remove(0);
  }

  for (int i=0; i < groups.size(); i++) groups.get(i).broadcast();
  
  background(0);
  text("groups: "+str(groups.size()), width/2, height/2);
  text("queued: "+str(clients.size()), width/2, height*0.25);
}


// The serverEvent function is called whenever a new client connects.
void serverEvent(Server server, Client client) {
  String incomingMessage = "A new client has connected:" + client.ip();
  println(incomingMessage);

  clients.add(client);
}

void disconnectEvent(Client client) {
  print("Client disconnected");
  if (clients.contains(client)) {
    clients.remove(client);
  }else{
      for (int i=0; i < groups.size (); i++) {
        Group g = groups.get(i);
        if (g.a == client) {
          g.alive = false;
          g.b.write(255);
          clients.add(g.b);
          groups.remove(g);
        } else if (g.b == client) {
          g.alive = false;
          g.a.write(255);
          clients.add(g.a);
          groups.remove(g);
        }
      }
  }
}

