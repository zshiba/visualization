final int CANVAS_WIDTH_DEFAULT  = 800;
final int CANVAS_HEIGHT_DEFAULT = 800;

final String DATA_FILE_PATH = "src/scatterplot_matrix/data_iris.csv";
/*
 *  data_*.csv frmat:
 *  Acknowledgement: data_iris.csv is from http://archive.ics.uci.edu/ml/datasets/Iris
 *  (Tha class labels were replaced with numerical values for making plotting data convenient.)
 *  By assuming the line index is base 0.
 *  a. Line#(0): FeatureName1,FeatureName2,FeatureName3,FeatureName4,Class
 *  b. Line#(1)~#(last): Feature1,Feature2,Feature3,Feature4,ClassLabel
 *
 *  FeatureN: float
 *  ClassLabel: int
 */

ScatterplotMatrixView scatterplotMatrixView;

void setup(){
  float canvasWidth = CANVAS_WIDTH_DEFAULT;
  float canvasHeight = CANVAS_HEIGHT_DEFAULT;
  size((int)canvasWidth, (int)canvasHeight);

  SampleManager sampleManager = createSampleMangerFrom(DATA_FILE_PATH);
  scatterplotMatrixView = new ScatterplotMatrixView(0.0f, 0.0f, canvasWidth, canvasHeight, sampleManager);
}

void draw(){
  scatterplotMatrixView.draw();
}

void mouseMoved(){
  scatterplotMatrixView.onMouseMovedTo(mouseX, mouseY);
}
void mouseClicked(){
  scatterplotMatrixView.onMouseClicked();
}
void mousePressed(){
  scatterplotMatrixView.onMousePressedAt(mouseX, mouseY);
}
void mouseDragged(){
  scatterplotMatrixView.onMouseDraggedTo(mouseX, mouseY);
}

SampleManager createSampleMangerFrom(String dataFilePath){
  SampleManager sampleManager = new SampleManager();
  String[] lines = loadStrings(dataFilePath);
  String[] labelData = splitTokens(trim(lines[0]), ",");
  for(int i = 0; i < labelData.length; i++)
    sampleManager.addLabel(trim(labelData[i]));

  for(int i = 1; i < lines.length; i++){
    String[] data = splitTokens(trim(lines[i]), ",");
    ArrayList<Float> features = new ArrayList<Float>();
    for(int j = 0; j < data.length - 1; j++)
      features.add(float(trim(data[j])));
    int classLabel = int(trim(data[data.length - 1]));
    sampleManager.add(new Sample(features, classLabel));
  }
  return sampleManager;
}
