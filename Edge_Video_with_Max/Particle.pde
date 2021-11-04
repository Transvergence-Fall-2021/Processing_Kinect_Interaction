class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  int alpha=20;
  int count=0;
  int type;
  int index = frameCount;

  Particle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r);
    body.setUserData(this);
    type = (frameCount/100)%10;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  void change() {
    alpha = 150;
    count = count+1;
    if((count==1)||(count%100==0)){
      play_music(type);
      println(index,"has count for",count);}
     
  }
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(#D299aa,alpha);
    if(alpha>20){alpha = alpha - 3;}
    noStroke();
    
    for (int i = 1; i < 10; i++ ) {
      ellipse(0,0 + i*2,i*2,i*2);
    }
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0.5;
    fd.friction = 0.3;
    fd.restitution = 0.3;
    
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(random(-3f,3f),random(0.5f,3f)));
    body.setAngularVelocity(random(-0.5,0.5));
  }






}
