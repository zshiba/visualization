public class ScatterplotView extends Viewport{

  private static final int USE_CLASS_INSTEAD_OF_FEATURE = -1; //super ad-hoc

  private ArrayList<Dot> dots;
  private SelectionArea selectionArea;

  public ScatterplotView(float viewX, float viewY, float viewWidth, float viewHeight, SampleManager sampleManager, int xFeatureIndex, int yFeatureIndex){
    super(viewX, viewY, viewWidth, viewHeight);

    float xMax;
    if(xFeatureIndex == USE_CLASS_INSTEAD_OF_FEATURE)
      xMax = (float)sampleManager.getMaxOfClassLabel();
    else
      xMax = sampleManager.getMaxOf(xFeatureIndex);
    float yMax;
    if(yFeatureIndex == USE_CLASS_INSTEAD_OF_FEATURE)
      yMax = (float)sampleManager.getMaxOfClassLabel();
    else
      yMax = sampleManager.getMaxOf(yFeatureIndex);

    float plotAreaWidth = this.getWidth() * 0.8f;
    float plotAreaHeight = this.getHeight() * 0.8f;
    float plotAreaX = this.getX() + (this.getWidth() - plotAreaWidth) / 2.0f;
    float plotAreaY = this.getY() + (this.getHeight() - plotAreaHeight) / 2.0f;;
    float xUnit = plotAreaWidth / xMax;
    float yUnit = plotAreaHeight / yMax;
    float dotSize = min(this.getWidth(), this.getHeight()) * 0.04f; //ad-hoc
    color dotColor = color(0, 0, 255, 128);
    color highlightColor = color(255, 165, 0, 128);
    float originX = plotAreaX;
    float originY = plotAreaY + plotAreaHeight;

    this.dots = new ArrayList<Dot>();
    for(int i = 0; i < sampleManager.getNumberOfSamples(); i++){
      Sample sample = sampleManager.getSampleAt(i);
      float dotX = originX;
      if(xFeatureIndex == USE_CLASS_INSTEAD_OF_FEATURE)
        dotX += (float)sample.getClassLabel() * xUnit;
      else
        dotX += sample.getFeatureAt(xFeatureIndex) * xUnit;

      float dotY = originY;
      if(yFeatureIndex == USE_CLASS_INSTEAD_OF_FEATURE)
        dotY -= (float)sample.getClassLabel() * yUnit;
      else
        dotY -= sample.getFeatureAt(yFeatureIndex) * yUnit;

      Dot dot = new Dot(dotX, dotY, dotSize, dotColor, highlightColor, sample);
      this.dots.add(dot);
    }

    this.selectionArea = null;
  }

  public void draw(){
    noFill();
    stroke(0);
    rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    for(int i = 0; i < this.dots.size(); i++)
      this.dots.get(i).draw();

    if(this.selectionArea != null)
      this.selectionArea.draw();
  }

  public void clearSelectionArea(){
    this.selectionArea = null;
    for(int i = 0; i < this.dots.size(); i++)
        this.dots.get(i).dehighlight();
  }
  public boolean isSelectionAreaReady(){
    if(this.selectionArea != null)
      return true;
    else
      return false;
  }
  public void prepareSelectionAreaWith(float startX, float startY){
    this.selectionArea = new SelectionArea(startX, startY, 0.0f, 0.0f);
  }
  public void updateSelectionAreaWith(float endX, float endY){
    if(this.selectionArea != null){
      float x = endX;
      if(endX < this.getX())
        x = this.getX();
      else if(this.getX() + this.getWidth() < endX)
        x = this.getX() + this.getWidth();
      float y = endY;
      if(endY < this.getY())
        y = this.getY();
      else if(this.getY() + this.getHeight() < endY)
        y = this.getY() + this.getHeight();
      this.selectionArea.updateAreaBy(x, y);
      this.highlightPoltsInSelectionArea();
    }
  }
  private void highlightPoltsInSelectionArea(){
    if(this.selectionArea != null){
      for(int i = 0; i < this.dots.size(); i++){
        Dot dot = this.dots.get(i);
        if(dot.isIn(this.selectionArea))
          dot.highlight();
        else
          dot.dehighlight();
      }
    }
  }
  public void highlightPoltsAt(int x, int y){
    for(int i = 0; i < this.dots.size(); i++){
      Dot dot = this.dots.get(i);
      if(dot.isIntersectingWith(x, y))
        dot.highlight();
      else
        dot.dehighlight();
    }
  }


  private class Dot{

    private Sample sample;

    private float dotX;
    private float dotY;
    private float dotSize;
    private color dotColor;
    private color highlightColor;

    public Dot(float dotX, float dotY, float dotSize, color dotColor, color highlightColor, Sample sample){
      this.dotX = dotX;
      this.dotY = dotY;
      this.dotSize = dotSize;
      this.dotColor = dotColor;
      this.highlightColor = highlightColor;
      this.sample = sample;
    }

    public void draw(){
      noStroke();
      if(this.sample.isHighlighted())
        fill(this.highlightColor);
      else
        fill(this.dotColor);
      ellipse(this.dotX, this.dotY, this.dotSize, this.dotSize);
    }

    public boolean isIntersectingWith(int x, int y){
      float r = this.dotSize / 2.0f;
      float distance = sqrt((this.dotX - x) * (this.dotX - x) + (this.dotY - y) * (this.dotY - y));
      if(distance <= r)
        return true;
      else
        return false;
    }
    public boolean isIn(Viewport area){ //ad-hoc return true only when the center of this dot is in the area
      if(area.getX() <= this.dotX && this.dotX <= area.getX() + area.getWidth()
          && area.getY() <= this.dotY && this.dotY <= area.getY() + area.getHeight())
        return true;
      else
        return false;
    }
    public void highlight(){
      this.sample.highlight();
    }
    public void dehighlight(){
      this.sample.dehighlight();
    }

  }


  private class SelectionArea extends Viewport{

    private float origianlX;
    private float originalY;
    private color areaColor;

    public SelectionArea(float viewX, float viewY, float viewWidth, float viewHeight){
      super(viewX, viewY, viewWidth, viewHeight);
      this.origianlX = viewX;
      this.originalY = viewY;
      this.areaColor = color(0, 255, 0, 40);
    }

    public void updateAreaBy(float endX, float endY){
      float upperLeftX;
      float upperLeftY;
      float bottomRightX;
      float bottomRightY;
      if(endX < this.origianlX){
        upperLeftX = endX;
        bottomRightX = this.origianlX;
      }else{
        upperLeftX = this.origianlX;
        bottomRightX = endX;
      }
      if(endY < this.originalY){
        upperLeftY = endY;
        bottomRightY = this.originalY;
      }else{
        upperLeftY = this.originalY;
        bottomRightY = endY;
      }

      this.set(upperLeftX, upperLeftY, bottomRightX - upperLeftX, bottomRightY - upperLeftY);
    }

    public void draw(){
      noStroke();
      fill(this.areaColor);
      rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    }

  }

}
