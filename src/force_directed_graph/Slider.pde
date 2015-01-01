public class Slider extends Viewport{

  private String title;
  private Knob knob;

  public Slider(String title, float initialValue, float min, float max){
    super();
    this.title = title;
    this.knob = new Knob(initialValue, min, max);
  }

  //@Override
  public void set(float viewX, float viewY, float viewWidth, float viewHeight){
    super.set(viewX, viewY, viewWidth, viewHeight);
    if(this.knob != null){
      float textHeight = textAscent() + textDescent();
      this.knob.set(viewX, viewY + textHeight, viewWidth, viewHeight / 3.0f);
    }
  }

  public void draw(){
    noStroke();
    fill(0);
    textAlign(LEFT, TOP);
    text(this.title, this.getX(), this.getY());

    this.knob.draw();
  }

  public float getValue(){
    return this.knob.getValue();
  }
  public void updateValueBy(int x){
    this.knob.updateValueBy(x);
  }

  //@Override
  public boolean isIntersectingWith(int x, int y){
    return this.knob.isIntersectingWith(x, y);
  }


  private class Knob extends Viewport{

    private float min;
    private float max;
    private float value;
    private float knobX;

    public Knob(float initialValue, float min, float max){
      super();
      this.min = min;
      this.max = max;
      this.setValue(initialValue);
    }

    //@Override
    public void set(float viewX, float viewY, float viewWidth, float viewHeight){
      super.set(viewX, viewY, viewWidth, viewHeight);
      this.setValue(this.value); //to update the tick
    }

    private void setValue(float value){
      this.value = value;
      this.knobX = (this.value - this.min) / (this.max - this.min) * this.getWidth() + this.getX();
    }
    public float getValue(){
      return this.value;
    }
    public void updateValueBy(int x){
      float value = ((float)x - this.getX()) / this.getWidth() * (this.max - this.min) + this.min;
      this.setValue(value);
    }

    public void draw(){
      fill(225, 225, 225);
      rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());

      fill(255);
      textAlign(LEFT, CENTER);
      text(this.min, this.getX(), this.getCenterY());
      textAlign(RIGHT, CENTER);
      text(this.max, this.getX() + this.getWidth(), this.getCenterY());

      stroke(0);
      line(this.knobX, this.getY(), this.knobX, this.getY() + this.getHeight());
    }

  }

}
