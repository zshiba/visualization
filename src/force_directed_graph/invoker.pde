final int CANVAS_WIDTH_DEFAULT  = 1000;
final int CANVAS_HEIGHT_DEFAULT = 600;

final String DATA_FILE_PATH = "src/force_directed_graph/data.csv";
/*
 *  data.csv frmat:
 *  By assuming the line index is base 0.
 *  a. Line#(0): NumberOfNodes
 *  b. Line#(1)~#(NumberOfNodes): NodeIndex,NodeMass
 *  c. Line#(NumberOfNodes + 1): NumberOfEdges
 *  d. Line#(NumberOfNodes + 1)~#(NumberOfNodes + 1 + NumberOfEdges): Node1Index,Node2Index,NaturalSpringLength
 */

ForceDirectedGraph forceDirectedGraph;
ControlPanel controlPanel;

void setup(){
  int canvasWidth = CANVAS_WIDTH_DEFAULT;
  int canvasHeight = CANVAS_HEIGHT_DEFAULT;
  size(canvasWidth, canvasHeight);
  forceDirectedGraph = createForceDirectedGraphFrom(DATA_FILE_PATH);
  forceDirectedGraph.set(0.0f, 0.0f, (float)canvasWidth * 0.8f, (float)canvasHeight);
//forceDirectedGraph.dumpInformation();
  controlPanel = new ControlPanel(forceDirectedGraph, forceDirectedGraph.getX() + forceDirectedGraph.getWidth(), 0.0f, (float)canvasWidth * 0.2f, (float)canvasHeight);
}

void draw(){
  background(255);
  forceDirectedGraph.draw();
  controlPanel.draw();
}

void mouseMoved(){
  if(forceDirectedGraph.isIntersectingWith(mouseX, mouseY))
    forceDirectedGraph.onMouseMovedAt(mouseX, mouseY);
}
void mousePressed(){
  if(forceDirectedGraph.isIntersectingWith(mouseX, mouseY))
    forceDirectedGraph.onMousePressedAt(mouseX, mouseY);
  else if(controlPanel.isIntersectingWith(mouseX, mouseY))
    controlPanel.onMousePressedAt(mouseX, mouseY);
}
void mouseDragged(){
  if(forceDirectedGraph.isIntersectingWith(mouseX, mouseY))
    forceDirectedGraph.onMouseDraggedTo(mouseX, mouseY);
  else if(controlPanel.isIntersectingWith(mouseX, mouseY))
    controlPanel.onMouseDraggedTo(mouseX, mouseY);
}
void mouseReleased(){
  if(forceDirectedGraph.isIntersectingWith(mouseX, mouseY))
    forceDirectedGraph.onMouseReleased();
}

ForceDirectedGraph createForceDirectedGraphFrom(String dataFilePath){
  ForceDirectedGraph forceDirectedGraph = new ForceDirectedGraph();
  String[] lines = loadStrings(dataFilePath);
  int numberOfNodes = int(trim(lines[0]));
  for(int i = 1; i < 1 + numberOfNodes; i++){
    String[] nodeData = splitTokens(trim(lines[i]), ",");
    int id = int(trim(nodeData[0]));
    float mass = float(trim(nodeData[1]));
    forceDirectedGraph.add(new Node(id, mass));
  }
  int numberOfEdges = int(trim(lines[numberOfNodes + 1]));
  for(int i = numberOfNodes + 2; i < numberOfNodes + 2 + numberOfEdges; i++){
    String[] edgeData = splitTokens(trim(lines[i]), ",");
    int id1 = int(trim(edgeData[0]));
    int id2 = int(trim(edgeData[1]));
    float edgeLength = float(trim(edgeData[2]));
    forceDirectedGraph.addEdge(id1, id2, edgeLength);
  }
  return forceDirectedGraph;
}
