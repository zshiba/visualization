final int CANVAS_WIDTH_DEFAULT  = 720;
final int CANVAS_HEIGHT_DEFAULT = 480;

final String DATA_FILE_PATH = "src/theme_river/data.csv";
/*
 *  data.csv format
 *  By assuming the line index is base 0.
 *  a. Line#(0): X_TITLE,X_LABEL1,X_LABEL2,...,X_LABEL_N
 *  b. Line#(1)~#(end): Y_TITLE,VALUE1,VALUE2,...,VALUE_N
 */

ThemeRiver themeRiver;

void setup(){
  int canvasWidth = CANVAS_WIDTH_DEFAULT;
  int canvasHeight = CANVAS_HEIGHT_DEFAULT;
  size(canvasWidth, canvasHeight);

  ThemeRiverModel model = createThemeRiverModelFrom(DATA_FILE_PATH);
  themeRiver = new ThemeRiver(0.0f, 0.0f, (float)canvasWidth, (float)canvasHeight, model);
}

void draw(){
  themeRiver.draw();
}

void mouseMoved(){
  themeRiver.onMouseMoved(mouseX, mouseY);
}

ThemeRiverModel createThemeRiverModelFrom(String dataFilePath){
  String[] lines = loadStrings(dataFilePath);
  String[] header = splitTokens(trim(lines[0]), ",");
  String xTitle = header[0];
  String[] xLabels = new String[header.length - 1];
  for(int i = 1; i < header.length; i++)
    xLabels[i - 1] = header[i];
  String[] yTitles = new String[lines.length - 1];
  float[][] values = new float[lines.length - 1][xLabels.length];
  for(int i = 1; i < lines.length; i++){
    String[] data = splitTokens(trim(lines[i]), ",");
    yTitles[i - 1] = trim(data[0]);
    for(int j = 1; j < data.length; j++)
      values[i - 1][j - 1] = float(data[j]);
  }
  return new ThemeRiverModel(xTitle, xLabels, yTitles, values);
}
