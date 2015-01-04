public class River{

  private ArrayList<Vertex> lower;
  private ArrayList<Vertex> upper;
  private color riverColor;
  private color dehighlightColor;
  private boolean isHighlighted;

  public River(ArrayList<Vertex> lower, ArrayList<Vertex> upper, color riverColor){
    this.lower = lower;
    this.upper = upper;
    this.riverColor = riverColor;
    this.dehighlightColor = color(red(this.riverColor), green(this.riverColor), blue(this.riverColor), 100);
    this.isHighlighted = true;
  }

  public void highlight(){
    this.isHighlighted = true;
  }
  public void dehighlight(){
    this.isHighlighted = false;
  }
  public boolean isColoredWith(color c){
    if(this.isNearlyEqual(red(this.riverColor), red(c)) && this.isNearlyEqual(green(this.riverColor), green(c)) && this.isNearlyEqual(blue(this.riverColor), blue(c)))
      return true;
    else
      return false;
  }
  private boolean isNearlyEqual(float f1, float f2){
    if(abs(f1 - f2) < 0.001f)
      return true;
    else
      return false;
  }

  public void draw(){
    noStroke();
    if(this.isHighlighted)
      fill(this.riverColor);
    else
      fill(this.dehighlightColor);

    Vertex upperStart = this.upper.get(0);
    Vertex upperEnd = this.upper.get(this.upper.size() - 1);
    Vertex lowerEnd = this.lower.get(this.lower.size() - 1);
    Vertex lowerStart = this.lower.get(0);

    beginShape();
    vertex(upperStart.getX(), upperStart.getY());
    curveVertex(upperStart.getX(), upperStart.getY());
    for(int i = 0; i < this.upper.size(); i++){
      Vertex v = this.upper.get(i);
      curveVertex(v.getX(), v.getY());
    }
    curveVertex(upperEnd.getX(), upperEnd.getY());
    vertex(upperEnd.getX(), upperEnd.getY());
    vertex(lowerEnd.getX(), lowerEnd.getY());
    curveVertex(lowerEnd.getX(), lowerEnd.getY());
    for(int i = this.lower.size() - 1; i >= 0; i--){
      Vertex v = this.lower.get(i);
      curveVertex(v.getX(), v.getY());
    }
    curveVertex(lowerStart.getX(), lowerStart.getY());
    vertex(lowerStart.getX(), lowerStart.getY());
    endShape();
  }

  public void drawIn(PGraphics g){
    g.noStroke();
    g.fill(this.riverColor);

    Vertex upperStart = this.upper.get(0);
    Vertex upperEnd = this.upper.get(this.upper.size() - 1);
    Vertex lowerEnd = this.lower.get(this.lower.size() - 1);
    Vertex lowerStart = this.lower.get(0);

    g.beginShape();
    g.vertex(upperStart.getX(), upperStart.getY());
    g.curveVertex(upperStart.getX(), upperStart.getY());
    for(int i = 0; i < this.upper.size(); i++){
      Vertex v = this.upper.get(i);
      g.curveVertex(v.getX(), v.getY());
    }
    g.curveVertex(upperEnd.getX(), upperEnd.getY());
    g.vertex(upperEnd.getX(), upperEnd.getY());
    g.vertex(lowerEnd.getX(), lowerEnd.getY());
    g.curveVertex(lowerEnd.getX(), lowerEnd.getY());
    for(int i = this.lower.size() - 1; i >= 0; i--){
      Vertex v = this.lower.get(i);
      g.curveVertex(v.getX(), v.getY());
    }
    g.curveVertex(lowerStart.getX(), lowerStart.getY());
    g.vertex(lowerStart.getX(), lowerStart.getY());
    g.endShape();
  }

}
