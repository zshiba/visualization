public class ParallelCoordinatesView extends Viewport{

  private static final color[] DEFAULT_COLORS = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)};

  private ArrayList<String> labels;
  private ArrayList<Sample> sample;

  private ArrayList<Axis> axes;
  private Axis selectedAxis;
  private Axis adjustedAxis;

  private HashMap<String, color> classColors;
  private String[] classLabels;

  public ParallelCoordinatesView(ArrayList<String> labels, ArrayList<Sample> samples, float viewX, float viewY, float viewWidth, float viewHeight){
    super(viewX, viewY, viewWidth, viewHeight);
    this.labels = labels;
    this.samples = samples;
//this.dumpInformation();
    this.initializeAxes();
    this.selectedAxis = null;
    this.adjustedAxis = null;

    this.classColors = new HashMap<String, color>();
    int colorIndex = 0;
    for(int i = 0; i < this.samples.size(); i++){
      String classLabel = this.samples.get(i).getClassLabel();
      if(this.classColors.get(classLabel) == null){
        color lineColor;
        if(colorIndex < DEFAULT_COLORS.length){
          lineColor = DEFAULT_COLORS[colorIndex];
          ++colorIndex;
        }else{
          lineColor = color((int)random(0, 250), (int)random(0, 250), (int)random(0, 250));
        }
        this.classColors.put(classLabel, lineColor);
      }
    }
    this.classLabels = this.classColors.keySet().toArray();
  }

  private void initializeAxes(){
    int numberOfFeatures = this.labels.size() - 1; //-1 is to exclude the last element of this.labels, "class"
    float xOffset = this.getWidth() / (float)numberOfFeatures;
    float x = this.getX() + xOffset / 2.0f;
    float startY = this.getY() + this.getHeight() * 0.1f;
    float endY = startY + this.getHeight() * 0.7f;
    this.axes = new ArrayList<Axis>();
    for(int i = 0; i < numberOfFeatures; i++){
      String title = this.labels.get(i);
      float max = MIN_FLOAT;
      float min = MAX_FLOAT;
      for(int j = 0; j < this.samples.size(); j++){
        Sample sample = this.samples.get(j);
        float feature = sample.getFeatureAt(i);
        if(feature > max)
          max = feature;
        if(feature < min)
          min = feature;
      }
      this.axes.add(new Axis(title, max, min, x, startY, x, endY));
      x += xOffset;
    }
  }

  public void draw(){
    background(255);
    textSize(16);
    this.drawLines();
    this.drawClassLebelLegends();

    for(int i = 0; i < this.axes.size(); i++){
      Axis axis = this.axes.get(i);
      if(this.selectedAxis == axis)
        axis.drawAsSelected();
      else
        axis.draw();
    }
  }
  private void drawLines(){
    for(int i = 0; i < this.samples.size(); i++){
      Sample sample = this.samples.get(i);
      if(sample.isHighlighted()){
        strokeWeight(2.0f);
        stroke(255, 178, 102);
      }else{
        strokeWeight(1.0f);
        boolean isInRange = true;
        for(int j = 0; j < sample.getNumberOfFeatures(); j++){
          Axis axis = this.axes.get(j);
          float feature = sample.getFeatureAt(j);
          isInRange = axis.isIncluding(feature);
          if(!isInRange)
            break;
        }
        if(isInRange){
          if(this.selectedAxis == null){
            String classLabel = sample.getClassLabel();
            color lineColor = this.classColors.get(classLabel);
            stroke(lineColor);
          }else{
            int selectedAxisIndex = this.axes.indexOf(this.selectedAxis);
            float targetFeature = sample.getFeatureAt(selectedAxisIndex);
            float level = this.selectedAxis.getLevelOf(targetFeature);
            color lineColor = lerpColor(color(255, 0, 180), color(0, 255, 180), level);
            stroke(lineColor);
          }
        }else{
          stroke(180);
        }
      }
      for(int j = 1; j < sample.getNumberOfFeatures(); j++){
        Axis axis1 = this.axes.get(j - 1);
        float x1 = axis1.getAxisX();
        float y1 = axis1.getYOf(sample.getFeatureAt(j - 1));
        Axis axis2 = this.axes.get(j);
        float x2 = axis2.getAxisX();
        float y2 = axis2.getYOf(sample.getFeatureAt(j));
        line(x1, y1, x2, y2);
      }
      if(sample.isHighlighted()){
        textAlign(LEFT, CENTER);
        for(int j = 0; j < sample.getNumberOfFeatures(); j++){
          float feature = sample.getFeatureAt(j);
          Axis axis = this.axes.get(j);
          float x = axis.getAxisX();
          float y = axis.getYOf(feature);
          text(feature, x, y);
        }
      }
    }
  }
  private void drawClassLebelLegends(){
    float x = this.getX() + this.getWidth() * 0.1f;
    float y = this.getY() + this.getHeight() * 0.9f;
    float yOffset = textAscent() + textDescent();
    textAlign(LEFT, CENTER);
    String label = this.labels.get(this.labels.size() - 1);
    text(label, x, y);
    x += textWidth(label + " "); //ad-hoc
    strokeWeight(2.0f);
    for(int i = 0; i < this.classLabels.length; i++){
      String classLabel = this.classLabels[i];
      if(this.selectedAxis == null){
        color lineColor = this.classColors.get(classLabel);
        stroke(lineColor);
      }else{
        fill(180);
        stroke(180);
      }
      line(x, y, x + 30.0f, y); //ad-hoc
      text(" : " + classLabel, x + 30.0f, y); ///ad-hoc
      y += yOffset;
    }
  }

  private boolean isPointInOnLine(float pointX, float pointY, float lineX1, float lineY1, float lineX2, float lineY2){
    if(lineX1 < lineX2){
      if(pointX < lineX1 || lineX2 < pointX)
        return false;
      if(lineY1 < lineY2){
        if(pointY < lineY1 || lineY2 < pointY)
          return false;
      }else{
        if(pointY < lineY2 || lineY1 < pointY)
          return false;
      }
    }else{
      if(pointX < lineX2 || lineX1 < pointX)
        return false;
      if(lineY1 < lineY2){
        if(pointY < lineY1 || lineY2 < pointY)
          return false;
      }else{
        if(pointY < lineY2 || lineY1 < pointY)
          return false;
      }
    }
    float abX = lineX2 - lineX1;
    float abY = lineY2 - lineY1;
    float apX = pointX - lineX1;
    float apY = pointY - lineY1;

    float crossProduct = abs(abX * apY - abY * apX);
    float lineLength = pow((lineX2 - lineX1) * (lineX2 - lineX1) + (lineY2 - lineY1) * (lineY2 - lineY1), 0.5f);
    float distance = crossProduct / lineLength;
    if(0.0f <= distance && distance <= 2.0f)
      return true;
    else
      return false;
  }

  public void onMouseClickedOn(float x, float y, int buttonType){
    if(this.isIntersectingWith(x, y)){
      boolean isSelected = false;
      for(int i = 0; i < this.axes.size(); i++){
        Axis axis = this.axes.get(i);
        if(axis.ofTitleAreaIsIntersectingWith(x, y)){
          this.selectedAxis = axis;
          isSelected = true;
          break;
        }
      }
      if(!isSelected)
        this.selectedAxis = null;
    }
  }
  public void onMouseMovedTo(float x, float y){
    for(int i = 0; i < this.samples.size(); i++){
      Sample sample = this.samples.get(i);
      for(int j = 1; j < sample.getNumberOfFeatures(); j++){
        Axis axis1 = this.axes.get(j - 1);
        float x1 = axis1.getAxisX();
        float y1 = axis1.getYOf(sample.getFeatureAt(j - 1));
        Axis axis2 = this.axes.get(j);
        float x2 = axis2.getAxisX();
        float y2 = axis2.getYOf(sample.getFeatureAt(j));
        if(isPointInOnLine(x, y, x1, y1, x2, y2)){
          sample.highlight();
          break;
        }else{
          sample.dehighlight();
        }
      }
    }
  }
  public void onMousePressedAt(float x, float y){
    for(int i = 0; i < this.axes.size(); i++){
      Axis axis = this.axes.get(i);
      if(axis.tryToPinchBy(x, y)){
        this.adjustedAxis = axis;
        break;
      }
    }
  }
  public void onMouseDragged(float fromX, float fromY, float toX, float toY){
    if(this.adjustedAxis != null)
      this.adjustedAxis.adjustKnobBy(fromY, toY);
  }
  public void onMouseReleasedAt(float x, float y){
    this.adjustedAxis = null;
  }

  private void dumpInformation(){
    println("---------------------");
    for(int i = 0; i < this.labels.size(); i++)
      print(this.labels.get(i).toString() + ", ");
    println();
    for(int i = 0; i < this.samples.size(); i++)
      println(i + ": " + this.samples.get(i).toString());
    println("---------------------");
  }

}
