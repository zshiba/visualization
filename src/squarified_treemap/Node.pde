public class Node extends Viewport{

  private int id;
  private int value;
  private Node parent;
  private ArrayList<Node> children;

  public Node(int id, int value){
    super();
    this.id = id;
    this.value = value;
    this.parent = null;
    this.children = new ArrayList<Node>();
  }

  public int getID(){
    return this.id;
  }
  public int getValue(){
    return this.value;
  }

  public void set(Node parent){
    this.parent = parent;
  }
  public Node getParent(){
    return this.parent;
  }

  public boolean isRoot(){
    if(this.parent == null)
      return true;
    else
      return false;
  }
  public boolean isLeaf(){
    if(this.children.isEmpty())
      return true;
    else
      return false;
  }

  public int getNumberOfChildren(){
    return this.children.size();
  }
  public Node getChildAt(int index){
    return this.children.get(index);
  }
  public void add(Node child){
    this.children.add(child);
    this.update();
    if(!this.isRoot())
      this.parent.notifyValueUpdated();
  }
  private void update(){
    int value = 0;
    for(int i = 0; i < this.children.size(); i++)
      value += this.children.get(i).getValue();
    this.value = value;
    //sort children in descending order of value
    ArrayList<Node> children = new ArrayList<Node>();
    while(!this.children.isEmpty()){
      Node max = this.children.get(0);
      for(int i = 1; i < this.children.size(); i++){
        Node target = this.children.get(i);
        if(target.getValue() > max.getValue())
          max = target;
      }
      children.add(max);
      this.children.remove(max);
    }
    this.children = children;
  }
  public void notifyValueUpdated(){
    this.update();
    if(!this.isRoot())
      this.parent.notifyValueUpdated();
  }

  public void draw(float offset){
    if(this.isHighlighted())
      fill(102, 102, 255);
    else
      fill(255);
    rect(this.getX() + offset, this.getY() + offset, this.getWidth() - (2.0f * offset), this.getHeight() - (2.0f * offset));
    textSize(14);
    textAlign(CENTER, CENTER);
    if(this.isHighlighted())
      fill(255);
    else
      fill(0);
    text(this.getID(), this.getCenterX(), this.getCenterY());
    for(int i = 0; i < this.getNumberOfChildren(); i++)
      this.getChildAt(i).draw(offset);
  }

  //@Override
  public String toString(){
    int parentID = -1; //ad-hoc
    if(!this.isRoot())
      parentID = this.getParent().getID();
    String childrenIDs = "[";
    for(int i = 0 ; i < this.children.size(); i++)
      childrenIDs += this.children.get(i).getID() + " ";
    childrenIDs += "]";
    return "ID:"          + this.id     + "," +
           "VALUE:"       + this.value  + "," +
           "PARENT_ID:"   + parentID    + "," +
           "CHILDREN_IDS" + childrenIDs;
  }
  public void printTree(){
    println(this.toString());
    for(int i = 0; i < this.children.size(); i++)
      this.children.get(i).printTree();
  }

}
