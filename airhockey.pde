/*
Air Hockey by Joshua Weiner

A fun 2-player game:
- Player 0 controls the lefthand paddle with W & S keys (Up and down, respectively).
- Player 1 controls the righthand paddle with O & K keys (Up and down, respectively).

When a goal is scored, the puck resets and changes color!

Have fun!
*/

Ball puck;

Paddle[] paddles = {};
color c;
boolean goalScored;
boolean collision;

void setup() {
  size(640, 360);
  collision = false;
  goalScored = false;
  paddles = (Paddle[])append(paddles, new Paddle(0));
  paddles = (Paddle[])append(paddles, new Paddle(1));
  puck = new Ball(320, 180, 20);
}

void draw() {
  background(200);
  fill(0,150,255);
  rect(0,130,20,100,0,14,14,0);
  rect(620,130,40,100,14);
  fill(100);
  rect(320,0,6,360);
  
  puck.update();
  puck.checkGoal();
  puck.display();
  puck.checkBoundaryCollision(); 
  paddles[0].update();
  paddles[0].display();
  paddles[0].checkPaddleCollision(puck);
  paddles[1].update();
  paddles[1].display();
  paddles[1].checkPaddleCollision(puck);
  
  if (goalScored) {
    setup();
  }
}

void keyPressed() {
  if (key == 'w') {
    paddles[0].posY -= 6;
  }
  else if (key == 's')  {
    paddles[0].posY += 6;
  }
  else if (key == 'o')
    paddles[1].posY -= 6;
  else if (key == 'k')
    paddles[1].posY += 6;
 }




class Ball {
  PVector position;
  PVector velocity;

  float radius, m;

  Ball(float x, float y, float r_) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity = velocity.mult(3);
    radius = r_;
    m = radius*.1;
  }

  void update() {
    position.add(velocity);
    if (velocity.mag() > 10)
      velocity = velocity.div(1.5);
    velocity.y *= .9999;
    velocity.x *= .9999;
  }

  void checkBoundaryCollision() {
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
  }
  
  void checkGoal() {
    if ((position.x < 20 || position.x > 620) && (position.y > 130  && position.y < 230)){
      c = color(random(0,255),random(0,255),random(0,255));
      goalScored = true;
      setup();
    }
  }

  void display() {
    noStroke();
    fill(c);
    ellipse(position.x, position.y, radius*2, radius*2);
  }
  
  
}

class Paddle {
  int num;
  float posY;
  float posX;
  PVector position;
  
  Paddle(int n) {
    num = n;
  }
  
  void update() {
    if (num == 0) {
      posY = constrain(posY, 100, 200);
      posX = 50;
      position = new PVector(posX, posY);
    }
    else {
      posY = constrain(posY, 100, 200);
      posX = 570;
      position = new PVector(posX, posY);
    };
  }
  
  void display() {
    noStroke();
    fill(255,0,0);
    if (num == 0)
      rect(posX, posY, 20, 60, 9);
    else
      rect(posX, posY, 20, 60, 9);
  }
  
  void checkPaddleCollision(Ball puck) {
      float newX;
      if (puck.position.x > 320)
        newX = posX + 20;
      else
        newX = posX;
      float xDist = abs(puck.position.x - newX);
      float yDist = abs(posY + 30 - puck.position.y);
      PVector vect = new PVector(xDist, yDist);
      
      //if ball is touching paddle       
      if (vect.mag() < 40 && collision == false) {
         if (yDist > xDist)
           puck.velocity.y *= -1;
         else
           puck.velocity.x *= -1;
         collision = true;
         puck.velocity.x *= 1.15;
         puck.velocity.y *= 1.15;
         puck.position.add(puck.velocity);
      }
      else if (vect.mag() < 80)
        collision = true;
      else
        collision = false;
  }
  }
