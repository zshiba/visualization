public class SquarifiedTreemap extends Viewport{

  private static final float OFFSET_DEFAULT = 2.0f;

  private float offset;
  private Node root;
  private Node viewRoot;

  public SquarifiedTreemap(float viewX, float viewY, float viewWidth, float viewHeight, Node root){
    this(viewX, viewY, viewWidth, viewHeight, root, OFFSET_DEFAULT);
  }

  public SquarifiedTreemap(float viewX, float viewY, float viewWidth, float viewHeight, Node root, float offset){
    super(viewX, viewY, viewWidth, viewHeight);
    this.offset = offset;
    this.root = root;
    this.viewRoot = null;
    this.switchViewRootTo(this.root);
  }

  private void switchViewRootTo(Node node){
    if(this.viewRoot != null)
      this.dehighlight(this.viewRoot);
    this.viewRoot = node;
    this.viewRoot.set(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    this.squarify(this.viewRoot);
  }

  private void squarify(Node node){
    if(!node.isLeaf()){
      float canvasX = node.getX() + this.offset;
      float canvasY = node.getY() + this.offset;
      float canvasWidth = node.getWidth() - (this.offset * 2.0f);
      float canvasHeight = node.getHeight() - (this.offset * 2.0f);

      float canvasArea = canvasWidth * canvasHeight;
      float vaRatio = canvasArea / (float)node.getValue();

      int i = 0;
      while(i < node.getNumberOfChildren()){
        float shorterSide;
        if(canvasWidth < canvasHeight)
          shorterSide = canvasWidth;
        else
          shorterSide = canvasHeight;

        float value = (float)node.getChildAt(i).getValue();
        float anotherSideC1 = value * vaRatio / shorterSide;
        float aspectRatioC1;
        if(anotherSideC1 < shorterSide)
          aspectRatioC1 = shorterSide / anotherSideC1;
        else
          aspectRatioC1 =  anotherSideC1 / shorterSide;
        if(i + 1 == node.getNumberOfChildren()){
          Node child = node.getChildAt(i);
          child.set(canvasX, canvasY, canvasWidth, canvasHeight);
          i++;
        }
        for(int j = i + 1; j < node.getNumberOfChildren(); j++){
          float c2Value = (float)node.getChildAt(j).getValue();
          float sumOfValue = value + c2Value;
          float anotherSideC2 = sumOfValue * vaRatio / shorterSide;
          float aspectRatioC2;
          if(anotherSideC2 < (shorterSide * (c2Value / sumOfValue)))
             aspectRatioC2 = (shorterSide * (c2Value / sumOfValue)) / anotherSideC2;
          else
             aspectRatioC2 = anotherSideC2 / (shorterSide * (c2Value / sumOfValue));
          if(aspectRatioC2 < aspectRatioC1){
            aspectRatioC1 = aspectRatioC2;
            anotherSideC1 = anotherSideC2;
            value = sumOfValue;
          }else{
            float x = canvasX;
            float y = canvasY;
            for(int k = i; k < j; k++){
              Node child = node.getChildAt(k);
              child.setX(x);
              child.setY(y);
              float childValue = (float)child.getValue();
              if(canvasWidth < canvasHeight){
                child.setWidth(shorterSide * (childValue / value));
                child.setHeight(anotherSideC1);
                x += shorterSide * (childValue / value);
              }else{
                child.setWidth(anotherSideC1);
                child.setHeight(shorterSide * (childValue / value));
                y += shorterSide * (childValue / value);
              }
            }
            i = j;
            if(canvasWidth < canvasHeight){
              canvasY += anotherSideC1;
              canvasHeight -= anotherSideC1;
            }else{
              canvasX += anotherSideC1;
              canvasWidth -= anotherSideC1;
            }
            break;
          }
        }
      }

      for(int n = 0; n < node.getNumberOfChildren(); n++)
        this.squarify(node.getChildAt(n));
    }
  }

  public void draw(){
    this.viewRoot.draw(this.offset);
  }

  public void onMouseMoved(int toX, int toY){
    this.tryToHiglight(this.viewRoot, toX, toY);
  }

  public void onMousePressed(int onX, int onY, int mouseButtonType){
    if(mouseButtonType == LEFT)
      zoomIn(mouseX, mouseY);
    else if(mouseButtonType == RIGHT)
      zoomOut();
  }

  private void dehighlight(Node node){
    node.dehighlight();
    for(int i = 0; i < node.getNumberOfChildren(); i++)
      this.dehighlight(node.getChildAt(i));
  }
  private void tryToHiglight(Node node, int x, int y){
    if(node.isIntersectingWith(x, y)){
      if(node.isLeaf())
        node.highlight();
      else
        node.dehighlight();
      for(int i = 0; i < node.getNumberOfChildren(); i++)
        this.tryToHiglight(node.getChildAt(i), x, y);
    }else{
      this.dehighlight(node);
    }
  }

  private void zoomIn(int x, int y){
    for(int i = 0; i < this.viewRoot.getNumberOfChildren(); i++){
      Node child = this.viewRoot.getChildAt(i);
      if(child.isIntersectingWith(x, y)){
        this.switchViewRootTo(child);
        break;
      }
    }
  }
  private void zoomOut(){
    if(this.viewRoot != this.root)
      this.switchViewRootTo(this.viewRoot.getParent());
  }

}
