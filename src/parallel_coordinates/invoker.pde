final int CANVAS_WIDTH_DEFAULT  = 900;
final int CANVAS_HEIGHT_DEFAULT = 600;

final String DATA_FILE_PATH = "src/parallel_coordinates/data_iris.csv";
/*
 *  data_*.csv frmat:
 *  Acknowledgement: data_iris.csv is from http://archive.ics.uci.edu/ml/datasets/Iris
 *  By assuming the line index is base 0.
 *  a. Line#(0): FeatureName1,FeatureName2,FeatureName3,FeatureName4,Class
 *  b. Line#(1)~#(last): Feature1,Feature2,Feature3,Feature4,ClassLabel
 *
 *  FeatureN: float
 *  ClassName: String
 */

ParallelCoordinatesView parallelCoordinatesView;

void setup(){
  float canvasWidth = CANVAS_WIDTH_DEFAULT;
  float canvasHeight = CANVAS_HEIGHT_DEFAULT;
  size((int)canvasWidth, (int)canvasHeight);

  ArrayList<String> labels = createLabelsFrom(DATA_FILE_PATH);
  ArrayList<Sample> samples = createSamplesFrom(DATA_FILE_PATH);
  parallelCoordinatesView = new ParallelCoordinatesView(labels, samples, 0.0f, 0.0f, canvasWidth, canvasHeight);
}

void draw(){
  parallelCoordinatesView.draw();
}

void mouseClicked(){
  parallelCoordinatesView.onMouseClickedOn(mouseX, mouseY);
}
void mouseMoved(){
  parallelCoordinatesView.onMouseMovedTo(mouseX, mouseY);
}
void mousePressed(){
  parallelCoordinatesView.onMousePressedAt(mouseX, mouseY);
}
void mouseDragged(){
  parallelCoordinatesView.onMouseDragged(pmouseX, pmouseY, mouseX, mouseY);
}
void mouseReleased(){
  parallelCoordinatesView.onMouseReleasedAt(mouseX, mouseY);
}

ArrayList<String> createLabelsFrom(String dataFilePath){
  ArrayList<String> labels = new ArrayList<String>();
  String[] lines = loadStrings(dataFilePath);
  String[] labelData = splitTokens(trim(lines[0]), ",");
  for(int i = 0; i < labelData.length; i++)
    labels.add(trim(labelData[i]));
  return labels;
}
ArrayList<Sample> createSamplesFrom(String dataFilePath){
  ArrayList<Sample> samples = new ArrayList<Sample>();
  String[] lines = loadStrings(dataFilePath);
  for(int i = 1; i < lines.length; i++){
    String[] data = splitTokens(trim(lines[i]), ",");
    ArrayList<Float> features = new ArrayList<Float>();
    for(int j = 0; j < data.length - 1; j++)
      features.add(float(trim(data[j])));
    String classLabel = trim(data[data.length - 1]);
    samples.add(new Sample(features, classLabel));
  }
  return samples;
}
