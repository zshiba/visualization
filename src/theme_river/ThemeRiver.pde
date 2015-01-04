public class ThemeRiver extends Viewport{

  private static final color[] DEFAULT_COLORS = {color(107, 110, 207),
                                          color(49, 130, 189),
                                          color(140, 162, 82),
                                          color(230, 85, 13),
                                          color(189, 158, 57),
                                          color(49,163,84),
                                          color(173, 73, 74),
                                          color(117, 107, 177),
                                          color(165, 81, 148),
                                          color(127, 127, 127),
                                          color(227, 119, 194)};

  private ThemeRiverModel model;

  private Axis xAxis;
  private LegendAxis yAxis;
  private Viewport floodArea;
  private ArrayList<River> rivers;
  private PGraphics pickBuffer;

  public ThemeRiver(float viewX, float viewY, float viewWidth, float viewHeight, ThemeRiverModel model){
    super(viewX, viewY, viewWidth, viewHeight);
    this.update(model);
  }

  private void update(ThemeRiverModel model){
    this.model = model;

    color[] colors = new color[this.model.getYTitles().length];
    for(int i = 0; i < colors.length; i++){
      if(i < DEFAULT_COLORS.length)
        colors[i] = DEFAULT_COLORS[i];
      else
        colors[i] = color((int)random(0, 256), (int)random(0, 256), (int)random(0, 256));
    }

    float yAxisX = this.getX();
    float yAxisY = this.getY();
    float yAxisWidth = this.getWidth() * 0.1f;
    float yAxisHeight = this.getHeight() * 0.85f;
    this.yAxis = new LegendAxis(yAxisX, yAxisY, yAxisWidth, yAxisHeight, this.model.getYTitles(), colors);

    float xAxisX = this.getX() + yAxisWidth;
    float xAxisY = this.getY() + yAxisHeight;
    float xAxisWidth = this.getWidth() - yAxisWidth;
    float xAxisHeight = this.getHeight() - yAxisHeight;
    float tickInterval = xAxisWidth / (float)(this.model.getNumberOfXLabels() + 1);
    this.xAxis = new Axis(xAxisX, xAxisY, xAxisWidth, xAxisHeight, this.model.getXTitle(), this.model.getXLabels(), tickInterval);

    float floodAreaHeight = yAxisHeight * 0.9f;
    float floodAreaX = xAxisX;
    float floodAreaY = yAxisY + (yAxisHeight - floodAreaHeight) / 2.0f;
    float floodAreaWidth = xAxisWidth;
    this.floodArea = new Viewport(floodAreaX, floodAreaY, floodAreaWidth, floodAreaHeight);

    int row = this.model.getNumberOfValueRow();
    int column = this.model.getNumberOfValueColumn();
    float max = MIN_FLOAT;
    for(int i = 0; i < column; i++){
      float sum = 0.0f;
      for(int j = 0; j < row; j++)
        sum += this.model.getValueAt(j, i);
      if(sum > max)
        max = sum;
    }

    float yUnit = floodAreaHeight / max;
    float[][] ys = new float[row + 1][column]; //"row + 1" for adding line_0
    for(int i = 0; i < column; i++)
      ys[0][i] = floodAreaY + floodAreaHeight;
    for(int i = 0; i < column; i++){
      for(int j = 1; j < row + 1; j++)
        ys[j][i] = ys[j - 1][i] - this.model.getValueAt(j - 1, i) * yUnit;
    }

    for(int i = 0; i < column; i++){ //centering
      float high = ys[0][i];
      float low = ys[row][i];
      float l = high - low;
      float offset = floodAreaHeight / 2.0f - l / 2.0f;
      for(int j = 0; j < row + 1; j++)
        ys[j][i] -= offset;
    }

    Vertex[][] vs = new Vertex[row + 1][column]; //"row + 1" for adding line_0
    for(int i = 0; i < row + 1; i++){
      float x = floodAreaX + tickInterval;
      for(int j = 0; j < column; j++){
        vs[i][j] = new Vertex(x, ys[i][j]);
        x += tickInterval;
      }
    }

    this.rivers = new ArrayList<River>();
    for(int i = 0; i < row; i++){
      ArrayList<Vertex> lower = new ArrayList<Vertex>();
      ArrayList<Vertex> upper = new ArrayList<Vertex>();
      for(int j = 0; j < column; j++){
        lower.add(vs[i][j]);
        upper.add(vs[i + 1][j]);
      }
      River river = new River(lower, upper, colors[i]);
      this.rivers.add(river);
    }

    this.pickBuffer = createGraphics((int)this.getWidth(), (int)this.getHeight());
    this.drawPickBuffer();
  }

  private void drawPickBuffer(){
    this.pickBuffer.beginDraw();
    this.pickBuffer.background(255);
    for(int i = 0; i < this.rivers.size(); i++)
      this.rivers.get(i).drawIn(this.pickBuffer);
    this.pickBuffer.endDraw();
  }

  public void draw(){
    background(255);
    this.xAxis.draw();
    this.yAxis.draw();
    for(int i = 0; i < this.rivers.size(); i++)
      this.rivers.get(i).draw();
  }

  public void onMouseMoved(int toX, int toY){
    if(this.floodArea.isIntersectingWith(toX, toY)){
      color c = this.pickBuffer.get(toX, toY);
      boolean isOnRiver = false;
      for(int i = 0; i < this.rivers.size(); i++){
        River river = this.rivers.get(i);
        if(river.isColoredWith(c)){
          river.highlight();
          isOnRiver = true;
        }else{
          river.dehighlight();
        }
      }
      if(!isOnRiver){
        for(int i = 0; i < this.rivers.size(); i++)
          this.rivers.get(i).highlight();
      }
    }
  }

}
