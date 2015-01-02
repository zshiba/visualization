public class Viewport{

  protected float viewX;
  protected float viewY;
  protected float viewWidth;
  protected float viewHeight;
  protected float viewCenterX;
  protected float viewCenterY;
  protected boolean isHighlighted;

  public Viewport(){
    this(-1.0f, -1.0f, -1.0f, -1.0f); //ad-hoc
  }
  public Viewport(float viewX, float viewY, float viewWidth, float viewHeight){
    this.set(viewX, viewY, viewWidth, viewHeight);
    this.dehighlight();
  }

  public void set(float viewX, float viewY, float viewWidth, float viewHeight){
    this.viewX = viewX;
    this.viewY = viewY;
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;
    this.updateCenter();
  }
  public void setX(float viewX){
    this.viewX = viewX;
    this.updateCenter();
  }
  public void setY(float viewY){
    this.viewY = viewY;
    this.updateCenter();
  }
  public void setWidth(float viewWidth){
    this.viewWidth = viewWidth;
    this.updateCenter();
  }
  public void setHeight(float viewHeight){
    this.viewHeight = viewHeight;
    this.updateCenter();
  }
  private void updateCenter(){
    this.viewCenterX = this.viewX + this.viewWidth / 2.0f;
    this.viewCenterY = this.viewY + this.viewHeight / 2.0f;
  }
  public void highlight(){
    this.isHighlighted = true;
  }
  public void dehighlight(){
    this.isHighlighted = false;
  }

  public float getX(){
    return this.viewX;
  }
  public float getY(){
    return this.viewY;
  }
  public float getWidth(){
    return this.viewWidth;
  }
  public float getHeight(){
    return this.viewHeight;
  }
  public float getCenterX(){
    return this.viewCenterX;
  }
  public float getCenterY(){
    return this.viewCenterY;
  }
  public boolean isHighlighted(){
    return this.isHighlighted;
  }
  public boolean isIntersectingWith(int x, int y){
    if(this.viewX <= x && x <= this.viewX + this.viewWidth){
      if(this.viewY <= y && y <= this.viewY + this.viewHeight)
        return true;
      else
        return false;
    }else{
      return false;
    }
  }

}
