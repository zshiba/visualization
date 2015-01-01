public class Axis{

  private static final int MODE_NO_KNOB_PINCHED  = 0;
  private static final int MODE_MAX_KNOB_PINCHED = 1;
  private static final int MODE_MIN_KNOB_PINCHED = 2;
  private static final int MODE_RANGE_PINCHED    = 3;

  private static final color COLOR_TITLE_DEFAULT  = color(0, 0, 0);
  private static final color COLOR_TITLE_SELECTED = color(255, 0, 0);
  private static final color COLOR_RANGE_DEFAULT  = color(0, 0, 255, 60);
  private static final color COLOR_RANGE_SELECTED = color(255, 0, 0, 60);

  private String title;
  private float max;
  private float min;
  private float currentMax;
  private float currentMin;
  private int mode;

  private float startX;
  private float startY;
  private float endX;
  private float endY;

  private Viewport titleView;
  private Viewport range;
  private Viewport maxKnob;
  private Viewport mainKnob;

  public Axis(String title, float max, float min, float startX, float startY, float endX, float endY){
    this.title = title;
    this.max = max;
    this.min = min;
    this.currentMax = max;
    this.currentMin = min;
    this.mode = MODE_NO_KNOB_PINCHED;
    if(this.min == this.max){
      this.min -= 0.00001f; //to avoid map() returning NaN
      this.currentMin -= this.min;
    }

    this.startX = startX;
    this.startY = startY;
    this.endX = endX;
    this.endY = endY;

    float rangeWidth = 10.0f; //ad-hoc
    float rangeX = this.startX - rangeWidth / 2.0f;
    float rangeY = this.startY;
    float rangeHeight = this.endY - this.startY;
    this.range = new Viewport(rangeX, rangeY, rangeWidth, rangeHeight);

    float maxKnobHeight = 8.0f; //ad-hoc
    float maxKnobX = rangeX;
    float maxKnobY = rangeY - maxKnobHeight;
    float maxKnobWidth = rangeWidth;
    this.maxKnob = new Viewport(maxKnobX, maxKnobY, maxKnobWidth, maxKnobHeight);

    float minKnobHeight = 8.0f; //ad-hoc
    float minKnobX = rangeX;
    float minKnobY = rangeY + rangeHeight;
    float minKnobWidth = rangeWidth;
    this.minKnob = new Viewport(minKnobX, minKnobY, minKnobWidth, minKnobHeight);

    textSize(16); //seems redundant but needed
    float titleWidth = textWidth(this.title);
    float titleX = this.startX - titleWidth / 2.0f;
    float titleHeight = textAscent() + textDescent();
    float titleY = this.startY - 2.0f * titleHeight;
    this.titleView = new Viewport(titleX, titleY, titleWidth, titleHeight);
  }

  public float getAxisX(){
    return this.startX;
  }
  public float getYOf(float value){
    return map(value, this.min, this.max, this.endY, this.startY);
  }

  public float getLevelOf(float value){
    return map(value, this.min, this.max, 0.0f, 1.0f);
  }

  public boolean isIncluding(float value){
    if(this.currentMin <= value && value <= this.currentMax)
      return true;
    else
      return false;
  }

  public boolean tryToPinchBy(float x, float y){
    if(this.maxKnob.isIntersectingWith(x, y)){
      this.mode = MODE_MAX_KNOB_PINCHED;
      return true;
    }else if(this.minKnob.isIntersectingWith(x, y)){
      this.mode = MODE_MIN_KNOB_PINCHED;
      return true;
    }else if(this.range.isIntersectingWith(x, y)){
      this.mode = MODE_RANGE_PINCHED;
      return true;
    }else{
      this.mode = MODE_NO_KNOB_PINCHED;
      return false;
    }
  }
  public void adjustKnobBy(float previousY, float currentY){
    if(this.mode == MODE_MAX_KNOB_PINCHED){
      if(currentY <= this.minKnob.getY()){
        if(this.startY <= currentY){
          this.currentMax = map(currentY, this.startY, this.endY, this.max, this.min);
          this.maxKnob.setY(currentY - this.maxKnob.getHeight());
        }else{
          this.currentMax = this.max;
          this.maxKnob.setY(this.startY - this.maxKnob.getHeight());
        }
        this.range.setY(this.maxKnob.getY() + this.maxKnob.getHeight());
        this.range.setHeight(this.minKnob.getY() - this.range.getY());
      }
    }else if(this.mode == MODE_MIN_KNOB_PINCHED){
      if(currentY >= this.maxKnob.getY() + this.maxKnob.getHeight()){
        if(currentY <= this.endY){
          this.currentMin = map(currentY, this.startY, this.endY, this.max, this.min);
          this.minKnob.setY(currentY);
        }else{
          this.currentMin = this.min;
          this.minKnob.setY(this.endY);
        }
        this.range.setHeight(this.minKnob.getY() - this.range.getY());
      }
    }else if(this.mode == MODE_RANGE_PINCHED){
      float yMove = currentY - previousY;
      if(yMove > 0){ //scroll down
        if(this.minKnob.getY() + yMove <= this.endY){
          this.minKnob.setY(this.minKnob.getY() + yMove);
          this.currentMin = map(this.minKnob.getY(), this.startY, this.endY, this.max, this.min);
          this.range.setY(this.range.getY() + yMove);
          this.maxKnob.setY(this.maxKnob.getY() + yMove);
          this.currentMax = map(this.maxKnob.getY() + this.maxKnob.getHeight(), this.startY, this.endY, this.max, this.min);
        }
      }else{ //scroll up
        if(this.maxKnob.getY() + this.maxKnob.getHeight() + yMove >= this.startY){
          this.maxKnob.setY(this.maxKnob.getY() + yMove);
          this.currentMax = map(this.maxKnob.getY() + this.maxKnob.getHeight(), this.startY, this.endY, this.max, this.min);
          this.range.setY(this.range.getY() + yMove);
          this.minKnob.setY(this.minKnob.getY() + yMove);
          this.currentMin = map(this.minKnob.getY(), this.startY, this.endY, this.max, this.min);
        }
      }
    }
  }

  public boolean ofTitleAreaIsIntersectingWith(float x, float y){
    return this.titleView.isIntersectingWith(x, y);
  }

  public void draw(){
    this.draw(COLOR_TITLE_DEFAULT, COLOR_RANGE_DEFAULT);
  }
  public void drawAsSelected(){
    this.draw(COLOR_TITLE_SELECTED, COLOR_RANGE_SELECTED);
  }
  private void draw(color titleColor, color rangeColor){
    this.drawTitleWith(titleColor);
    this.drawAxis();
    this.drawRangeWith(rangeColor);
  }
  private void drawTitleWith(color backgroudColor){
    fill(backgroudColor);
    textAlign(LEFT, TOP);
    text(this.title, this.titleView.getX(), this.titleView.getY());
  }
  private void drawAxis(){
    fill(0);
    stroke(0);
    strokeWeight(1.5f);
    line(this.startX, this.startY, this.endX, this.endY); //axis
    line(this.startX - this.range.getWidth(), this.startY, this.startX + this.range.getWidth(), this.startY); //top tick
    line(this.endX - this.range.getWidth(), this.endY, this.endX + this.range.getWidth(), this.endY); //bottom tick
    textAlign(RIGHT, CENTER);
    text(this.max, this.startX - this.range.getWidth(), this.startY); //max
    text(this.min, this.endX - this.range.getWidth(), this.endY); //min
  }
  private void drawRangeWith(color rangeColor){
    noStroke();
    fill(200, 200, 200, 200);
    rect(this.startX - this.range.getWidth() / 2.0f, this.startY, this.range.getWidth(), this.range.getY() - this.startY);
    fill(rangeColor);
    rect(this.range.getX(), this.range.getY(), this.range.getWidth(), this.range.getHeight());
    fill(200, 200, 200, 200);
    rect(this.endX - this.range.getWidth() / 2.0f, this.range.getY() + this.range.getHeight(), this.range.getWidth(), this.endY - (this.range.getY() + this.range.getHeight()));
    fill(0);
    rect(this.maxKnob.getX(), this.maxKnob.getY(), this.maxKnob.getWidth(), this.maxKnob.getHeight()); //maxKnob
    stroke(0);
    line(this.maxKnob.getX() - this.maxKnob.getWidth() / 2.0f, this.maxKnob.getY() + this.maxKnob.getHeight(), this.maxKnob.getX() + this.maxKnob.getWidth() * 3.0f / 2.0f, this.maxKnob.getY() + this.maxKnob.getHeight());
    rect(this.minKnob.getX(), this.minKnob.getY(), this.minKnob.getWidth(), this.minKnob.getHeight()); //minKnob
    line(this.minKnob.getX() - this.minKnob.getWidth() / 2.0f, this.minKnob.getY(), this.minKnob.getX() + this.minKnob.getWidth() * 3.0f / 2.0f, this.minKnob.getY());
    textAlign(RIGHT, CENTER);
    if(this.currentMax != this.max)
      text(this.currentMax, this.maxKnob.getX() - this.maxKnob.getWidth(), this.maxKnob.getY() + this.maxKnob.getHeight()); //currentMax
    if(this.currentMin != this.min)
      text(this.currentMin, this.minKnob.getX() - this.minKnob.getWidth(), this.minKnob.getY()); //currentMin
  }

}
