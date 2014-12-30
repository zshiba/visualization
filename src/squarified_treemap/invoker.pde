int CANVAS_WIDTH_DEFAULT  = 720;
int CANVAS_HEIGHT_DEFAULT = 480;

String SHF_FILE_PATH = "src/squarified_treemap/hierarchy_data.shf";
/*
 *  .shf (Simple Hierarchy Format)
 *  By assuming the line index is base 0.
 *  a. Line#(0): NumberOfLeaves
 *  b. Line#(1)~#(NumberOfLeaves): LeafIndex LeafValue
 *  c. Line#(NumberOfLeaves + 1): NumberOfParentChildRelationships
 *  d. Line#(NumberOfLeaves + 1)~#(NumberOfLeaves + 1 + NumberOfParentChildRelationships): ParentIndex ChildIndex
 */


SquarifiedTreemap squarifiedTreemap;

void setup(){
  int canvasWidth = CANVAS_WIDTH_DEFAULT;
  int canvasHeight = CANVAS_HEIGHT_DEFAULT;
  size(canvasWidth, canvasHeight);

  Node root = buildTreeFrom(SHF_FILE_PATH);
  squarifiedTreemap = new SquarifiedTreemap(0.0f, 0.0f, (float)canvasWidth, (float)canvasHeight, root);
}

void draw(){
  squarifiedTreemap.draw();
}

void mouseMoved(){
  squarifiedTreemap.onMouseMoved(mouseX, mouseY);
}

void mousePressed(){
  squarifiedTreemap.onMousePressed(mouseX, mouseY, mouseButton);
}

Node buildTreeFrom(String shfFilePath){
  String lines[] = loadStrings(shfFilePath);
  int numberOfLeaves = int(lines[0]);
  int start = 1;
  int end = start + numberOfLeaves;
  ArrayList<Node> nodes = new ArrayList<Node>();
  for(int i = start; i < end; i++){
    String[] data = split(lines[i], " ");
    int id = int(data[0]);
    int value = int(data[1]);
    Node leaf = new Node(id, value);
    nodes.add(leaf);
  }
  int numberOfRelationShips = int(lines[end]);
  start = end + 1;
  end = start + numberOfRelationShips;
  for(int j = start; j < end; j++){
    String[] data = split(lines[j], " ");
    int parentID = int(data[0]);
    int childID = int(data[1]);
    Node parent = null;
    Node child = null;
    for(int k = 0; k < nodes.size(); k++){
      Node node = nodes.get(k);
      if(parent == null && node.getID() == parentID)
        parent = node;
      else if(child == null && node.getID() == childID)
        child = node;
      if(parent != null && child != null)
        break;
    }
    if(parent == null){
      parent = new Node(parentID, 0);
      nodes.add(parent);
    }
    if(child == null){
      child = new Node(childID, 0);
      nodes.add(child);
    }
    child.set(parent);
    parent.add(child);
  }
  Node root = null;
  for(int k = 0; k < nodes.size(); k++){
    Node node = nodes.get(k);
    if(node.isRoot()){
      root = node;
      break;
    }
  }
  return root
}
