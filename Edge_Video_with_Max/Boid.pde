class Boid {
  PVector pos;
  PVector vel;
  float green;

  Boid() {
    pos=new PVector(random(width), random(height));
    vel=new PVector();
  }

  void update() {
    float scale=0.005;
    float noiseValue=noise(pos.x*scale, pos.y*scale,frameCount*scale);
    float angle=noiseValue*TWO_PI*5;
    
    float magnitude=noise(pos.x*scale+1111, pos.y*scale+2222,frameCount*scale)*5;
    vel.set(cos(angle)*magnitude, sin(angle)*magnitude);
    
    green=int(random(107,133));

    pos.add(vel);
    if (pos.x<0 || pos.x>width || pos.y<0 || pos.y>height) {
      pos.set(random(width), random(height));
    }
  }

  void display() {

    stroke(#7A8C68,150);
    point(pos.x, pos.y);
  }
}
