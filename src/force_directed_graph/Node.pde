public class Node{

  private int id;
  private float mass;
  private ArrayList<Node> adjacents;
  private ArrayList<Float> naturalSpringLengths;
  private float x;
  private float y;
  private float diameter;
  private float velocityX;
  private float velocityY;
  private boolean isHighlighted;

  public Node(int id, float mass){
    this.id = id;
    this.mass = mass;
    this.adjacents = new ArrayList<Node>();
    this.naturalSpringLengths = new ArrayList<Float>();

    this.set(-1.0f, -1.0f, -1.0f); //ad-hoc
    this.setVelocities(0.0f, 0.0f);
    this.isHighlighted = false;
  }

  public void add(Node adjacent, float naturalSpringLength){
    this.adjacents.add(adjacent);                       //the order of elements in the two ArrayLists must be the same.
    this.naturalSpringLengths.add(naturalSpringLength); //better to capture these as like key-value pairs...
  }
  public void set(float x, float y){
    this.x = x;
    this.y = y;
  }
  public void set(float x, float y, float diameter){
    this.set(x, y);
    this.diameter = diameter;
  }
  public void setVelocities(float velocityX, float velocityY){
    this.velocityX = velocityX;
    this.velocityY = velocityY;
  }

  public int getID(){
    return this.id;
  }
  public float getMass(){
    return this.mass;
  }
  public float getX(){
    return this.x;
  }
  public float getY(){
    return this.y;
  }
  public float getDiameter(){
    return this.diameter;
  }
  public float getVelocityX(){
    return this.velocityX;
  }
  public float getVelocityY(){
    return this.velocityY;
  }
  public int getSizeOfAdjacents(){
    return this.adjacents.size();
  }
  public Node getAdjacentAt(int index){
    return this.adjacents.get(index);
  }
  public float getNaturalSpringLengthAt(int index){
    return this.naturalSpringLengths.get(index);
  }

  public void draw(){
    if(this.isHighlighted){
      stroke(255, 178, 102);
      fill(255, 178, 102);
    }else{
      stroke(51, 51, 255);
      fill(102, 178, 255);
    }
    ellipse(this.x, this.y, this.diameter, this.diameter);

    if(this.isHighlighted){ //tooltip
      fill(0);
      textAlign(CENTER, BOTTOM);
      text("id: " + this.id, this.x, this.y);
      textAlign(CENTER, TOP);
      text("mass: " + this.mass, this.x, this.y);
    }
  }

  public void highlight(){
    this.isHighlighted = true;
  }
  public void dehighlight(){
    this.isHighlighted = false;
  }
  public boolean isIntersectingWith(int x, int y){
    float r = this.diameter / 2.0f;
    if(this.x - r <= x && x <= this.x + r && this.y - r <= y && y <= this.y + r)
      return true;
    else
      return false;
  }

  //@Override
  public String toString(){
    String adjacentIDsAndNaturalLengths = "[";
    for(int i = 0; i < this.adjacents.size(); i++)
      adjacentIDsAndNaturalLengths += this.adjacents.get(i).getID() + "(" + this.naturalSpringLengths.get(i) + "),";
    adjacentIDsAndNaturalLengths += "]";
    return "ID:" + this.id +
           ",MASS:" + this.mass +
           ",ADJACENTS(NATURAL_LEGTH):" + adjacentIDsAndNaturalLengths +
           ",X:" + this.x +
           ",Y:" + this.y +
           ",DIAMETER:" + this.diameter +
           ",HIGHLIGHTED:" + this.isHighlighted;
  }

}
