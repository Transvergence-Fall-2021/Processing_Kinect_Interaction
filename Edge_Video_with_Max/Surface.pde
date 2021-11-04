// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// An uneven surface boundary

class Surface {
  float sum_x=0;
  float sum_y=0;
  int count=0;
  // We'll keep track of all of the surface points
  ArrayList<Vec2> surface;
  EdgeVertex eA, eB;
  float[] save = new float[2];
  Body body;


  Surface(Blob b) {
    surface = new ArrayList<Vec2>();

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    float theta = 0;
    try{
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null){
            if ((eA.x*width-save[0]>1)|(eA.y*height-save[1]>1)|
            (eA.x*width-save[0]<-1)|(eA.y*height-save[1]<-1)){
      //if(m==0){
        //surface.add(new Vec2(eA.x*width, height));}
      
      // Store the vertex in screen coordinates
      surface.add(new Vec2(eA.x*width, eA.y*height));
      if(m==b.getEdgeNb()){
        surface.add(new Vec2(eA.x*width, height));
      }
      
      save[0] = eA.x*width;
      save[1] = eA.y*height;
    }
          }
        }
        //println("surface",surface);

    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface.get(i));
      vertices[i] = edge;
    }
    // Create the chain!
    chain.createChain(vertices,vertices.length);

    // The edge chain is now attached to a body via a fixture
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    body = box2d.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain,1);
 body.setUserData(this);

  }
      catch (NullPointerException e) {
    print("No Surface");
  }
  }
  

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(2);
    noStroke();
    fill(#938Da7,200);
    beginShape();
    for (Vec2 v: surface) {
      vertex(v.x,v.y);
      sum_x+=v.x;
      sum_y+=v.y;
      count+=1;
    }
    endShape();
    mouse.set(sum_x/count,sum_y/count);
  }
    void destroyBody() {
    box2d.destroyBody(body);
  }

}
