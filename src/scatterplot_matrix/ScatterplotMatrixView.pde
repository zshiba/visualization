public class ScatterplotMatrixView extends Viewport{

  private static final int SELECTION_MODE_BY_POINT = 1;
  private static final int SELECTION_MODE_BY_AREA  = 2;

  private SampleManager sampleManager;
  private ArrayList<LabelView> labelViews;
  private ArrayList<ScatterplotView> scatterplotViews;
  private int selectionMode;

  public ScatterplotMatrixView(float viewX, float viewY, float viewWidth, float viewHeight, SampleManager sampleManager){
    super(viewX, viewY, viewWidth, viewHeight);
    this.sampleManager = sampleManager;
//this.sampleManager.dumpInfo();

    this.labelViews = this.createLabelViews();
    this.scatterplotViews = this.createScatterplotViews();
    this.selectionMode = SELECTION_MODE_BY_POINT;
  }

  private ArrayList<LabelView> createLabelViews(){
    ArrayList<LabelView> labelViews = new ArrayList<LabelView>();
    float labelViewHeight = (textAscent() + textDescent()) * 2.0f;
    float labelViewX = this.getX() + labelViewHeight;
    float labelViewY = this.getY();
    float labelViewWidth = (this.getWidth() - labelViewHeight * 2.0f) / (float)this.sampleManager.getNumberOfLabels();
    for(int i = 0; i < this.sampleManager.getNumberOfLabels(); i++){
      LabelView labelView = new LabelView(labelViewX, labelViewY, labelViewWidth, labelViewHeight, this.sampleManager.getLabelAt(i), LabelView.LAYOUT_HORIZONTAL);
      labelViews.add(labelView);
      labelViewX += labelViewWidth;
    }
    labelViewX = this.getX();
    labelViewWidth = (textAscent() + textDescent()) * 2.0f;
    labelViewY = this.getY() + labelViewWidth;
    labelViewHeight = (this.getHeight() - labelViewWidth * 2.0f) / (float)this.sampleManager.getNumberOfLabels();
    for(int i = 0; i < this.sampleManager.getNumberOfLabels(); i++){
      LabelView labelView = new LabelView(labelViewX, labelViewY, labelViewWidth, labelViewHeight, this.sampleManager.getLabelAt(i), LabelView.LAYOUT_VERTICAL);
      labelViews.add(labelView);
      labelViewY += labelViewHeight;
    }
    return labelViews;
  }
  private ArrayList<ScatterplotView> createScatterplotViews(){
    ArrayList<ScatterplotView> scatterplotViews = new ArrayList<ScatterplotView>();
    float scatterplotViewX = this.getX() + (textAscent() + textDescent()) * 2.0f;
    float scatterplotViewY = this.getY() + (textAscent() + textDescent()) * 2.0f;
    float scatterplotViewWidth = (this.getWidth() - (textAscent() + textDescent()) * 2.0f * 2.0f) / (float)this.sampleManager.getNumberOfLabels();
    float scatterplotViewHeight = (this.getHeight() - (textAscent() + textDescent()) * 2.0f * 2.0f) / (float)this.sampleManager.getNumberOfLabels();
    for(int i = 0; i < this.sampleManager.getNumberOfLabels(); i++){
      for(int j = 0; j < this.sampleManager.getNumberOfLabels(); j++){
        int xFeatureIndex = j;
        if(j == this.sampleManager.getNumberOfLabels() - 1)
          xFeatureIndex = ScatterplotView.USE_CLASS_INSTEAD_OF_FEATURE;
        int yFeatureIndex = i;
        if(i == this.sampleManager.getNumberOfLabels() - 1)
          yFeatureIndex = ScatterplotView.USE_CLASS_INSTEAD_OF_FEATURE;

        ScatterplotView scatterplotView = new ScatterplotView(scatterplotViewX, scatterplotViewY, scatterplotViewWidth, scatterplotViewHeight, this.sampleManager, xFeatureIndex, yFeatureIndex);
        scatterplotViews.add(scatterplotView);
        scatterplotViewX += scatterplotViewWidth;
      }
      scatterplotViewX = this.getX() + (textAscent() + textDescent()) * 2.0f;
      scatterplotViewY += scatterplotViewHeight;
    }
    return scatterplotViews;
  }

  public void draw(){
    background(255);
    for(int i = 0; i < this.labelViews.size(); i++)
      this.labelViews.get(i).draw();
    for(int i = 0; i < this.scatterplotViews.size(); i++)
      this.scatterplotViews.get(i).draw();
  }

  public void onMouseMovedTo(int x, int y){
    if(this.selectionMode == SELECTION_MODE_BY_POINT){
      if(this.isIntersectingWith(x, y)){
        for(int i = 0; i < this.scatterplotViews.size(); i++){
          ScatterplotView scatterplotView = this.scatterplotViews.get(i);
          if(scatterplotView.isIntersectingWith(x, y)){
            scatterplotView.highlightPoltsAt(x, y);
            break;
          }
        }
      }
    }
  }
  public void onMouseClicked(){
    this.clearSelectionArea();
    this.selectionMode = SELECTION_MODE_BY_POINT;
  }
  public void onMousePressedAt(int x, int y){
    this.clearSelectionArea();
    this.selectionMode = SELECTION_MODE_BY_AREA;
    for(int i = 0; i < this.scatterplotViews.size(); i++){
      ScatterplotView scatterplotView = this.scatterplotViews.get(i);
      if(scatterplotView.isIntersectingWith(x, y))
        scatterplotView.prepareSelectionAreaWith((float)x, (float)y);
    }
  }
  public void onMouseDraggedTo(int x, int y){
    for(int i = 0; i < this.scatterplotViews.size(); i++){
      ScatterplotView scatterplotView = this.scatterplotViews.get(i);
      if(scatterplotView.isSelectionAreaReady())
        scatterplotView.updateSelectionAreaWith((float)x, (float)y);
    }
  }
  private void clearSelectionArea(){
    for(int i = 0; i < this.scatterplotViews.size(); i++){
      ScatterplotView scatterplotView = this.scatterplotViews.get(i);
      if(scatterplotView.isSelectionAreaReady())
        scatterplotView.clearSelectionArea();
    }
  }


  private class LabelView extends Viewport{

    public static final int LAYOUT_HORIZONTAL = 1;
    public static final int LAYOUT_VERTICAL   = 2;

    private String label;
    private int layout;

    public LabelView(float viewX, float viewY, float viewWidth, float viewHeight, String label, int layout){
      super(viewX, viewY, viewWidth, viewHeight);
      this.label = label;
      this.layout = layout;
    }

    public void draw(){
      fill(0);
      if(this.layout == LAYOUT_HORIZONTAL){
        textAlign(CENTER, CENTER);
        text(this.label, this.getCenterX(), this.getCenterY());
      }else if(this.layout == LAYOUT_VERTICAL){
        pushMatrix();
        translate(this.getCenterX(), this.getCenterY());
        rotate(HALF_PI * 3.0f);
        textAlign(CENTER, CENTER);
        text(this.label, 0.0f, 0.0f);
        popMatrix();
      }
    }

  }

}
