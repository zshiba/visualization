public class ControlPanel extends Viewport{

  public interface OnValueChangeListener{
    public abstract void onSpringConstantChangedTo(float value);
    public abstract void onCoulombConstantChangedTo(float value);
    public abstract void onDampingCoefficientChangedTo(float value);
    public abstract void onTimeStepChangedTo(float value);
  }

  private OnValueChangeListener listener;
  private Slider springConstantSlider;
  private Slider coulombConstantSlider;
  private Slider dampingCoefficientSlider;
  private Slider timeStepSlider;

  public ControlPanel(OnStateChangeListener listener, float viewX, float viewY, float viewWidth, float viewHeight){
    super(viewX, viewY, viewWidth, viewHeight);
    this.listener = listener;

    float sliderViewX = viewX + viewWidth * 0.1f;
    float sliderViewWidth = viewWidth * 0.8f;
    float sliderViewHeight = viewHeight / 4.0f;
    float sliderViewY = viewY;
    this.springConstantSlider = new Slider("Spring Constant", ForceDirectedGraph.SPRING_CONSTANT_DEFAULT, 0.1f, 1.2f);
    this.springConstantSlider.set(sliderViewX, sliderViewY, sliderViewWidth, sliderViewHeight);
    sliderViewY += sliderViewHeight;
    this.coulombConstantSlider = new Slider("Coulomb Constant", ForceDirectedGraph.COULOMB_CONSTANT_DEFAULT, 0.0f, 1000.0f);
    this.coulombConstantSlider.set(sliderViewX, sliderViewY, sliderViewWidth, sliderViewHeight);
    sliderViewY += sliderViewHeight;
    this.dampingCoefficientSlider = new Slider("Damping Coefficient", ForceDirectedGraph.DAMPING_COEFFICIENT_DEFAULT, 0.1f, 0.9f);
    this.dampingCoefficientSlider.set(sliderViewX, sliderViewY, sliderViewWidth, sliderViewHeight);
    sliderViewY += sliderViewHeight;
    this.timeStepSlider = new Slider("Time Step", ForceDirectedGraph.TIME_STEP_DEFAULT, 0.1f, 1.5f);
    this.timeStepSlider.set(sliderViewX, sliderViewY, sliderViewWidth, sliderViewHeight);
  }

  public void draw(){
    noStroke();
    fill(245);
    rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    this.springConstantSlider.draw();
    this.coulombConstantSlider.draw();
    this.dampingCoefficientSlider.draw();
    this.timeStepSlider.draw();
  }

  public void onMousePressedAt(int x, int y){
    if(this.springConstantSlider.isIntersectingWith(x,y)){
      this.springConstantSlider.updateValueBy(x);
      float value = this.springConstantSlider.getValue();
      this.listener.onSpringConstantChangedTo(value);
    }else if(this.coulombConstantSlider.isIntersectingWith(x,y)){
      this.coulombConstantSlider.updateValueBy(x);
      float value = this.coulombConstantSlider.getValue();
      this.listener.onCoulombConstantChangedTo(value);
    }else if(this.dampingCoefficientSlider.isIntersectingWith(x,y)){
      this.dampingCoefficientSlider.updateValueBy(x);
      float value = this.dampingCoefficientSlider.getValue();
      this.listener.onDampingCoefficientChangedTo(value);
    }else if(this.timeStepSlider.isIntersectingWith(x,y)){
      this.timeStepSlider.updateValueBy(x);
      float value = this.timeStepSlider.getValue();
      this.listener.onTimeStepChangedTo(value);
    }
  }
  public void onMouseDraggedTo(int x, int y){
    this.onMousePressedAt(x, y);
  }

}
