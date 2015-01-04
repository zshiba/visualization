public class LegendAxis extends Viewport{

  private ArrayList<LegendView> legendViews;

  public LegendAxis(float viewX, float viewY, float viewWidth, float viewHeight, String[] legends, color[] legendColors){
    super(viewX, viewY, viewWidth, viewHeight);

    this.legendViews = new ArrayList<LegendView>();
    float h = (textAscent() + textDescent()) * 2.0f;
    float gapY = (this.getHeight() - h * legends.length) / 2.0f;
    float x = this.getX() + this.getWidth() * 0.1f;
    float y = gapY;
    float w = this.getWidth() * 0.8f;
    for(int i = legends.length - 1; i >= 0; i--){
      LegendView legendView = new LegendView(x, y, w, h, legends[i], legendColors[i]);
      legendViews.add(legendView);
      y += h;
    }
  }

  public void draw(){
    stroke(0);
    float x = this.getX() + this.getWidth();
    line(x, this.getY(), x, this.getY() + this.getHeight());
    for(int i = 0; i < this.legendViews.size(); i++)
      this.legendViews.get(i).draw();
  }

  private class LegendView extends Viewport{

    private String legend;
    private color legendColor;

    public LegendView(float viewX, float viewY, float viewWidth, float viewHeight, String legend, color legendColor){
      super(viewX, viewY, viewWidth, viewHeight);
      this.legend = legend;
      this.legendColor = legendColor;
    }

    public void draw(){
      noStroke();
      fill(this.legendColor);
      rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
      fill(255);
      textAlign(CENTER, CENTER);
      text(this.legend, this.getCenterX(), this.getCenterY());
    }

  }

}
