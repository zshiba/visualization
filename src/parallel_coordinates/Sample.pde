public class Sample{

  private ArrayList<Float> features;
  private String classLabel;
  private boolean highlighted; //wanted to name isHighlighted... This is a temporal fix for processing.js

  public Sample(ArrayList<Float> features, String classLabel){
    this.features = features;
    this.classLabel = classLabel;
    this.highlighted = false;
  }

  public float getFeatureAt(int index){
    return this.features.get(index);
  }
  public int getNumberOfFeatures(){
    return this.features.size();
  }
  public String getClassLabel(){
    return this.classLabel;
  }
  public boolean isHighlighted(){
    return this.highlighted;
  }
  public void highlight(){
    this.highlighted = true;
  }
  public void dehighlight(){
    this.highlighted = false;
  }

  //@Override
  public String toString(){
    String content = "";
    for(int i = 0; i < this.features.size(); i++)
      content += this.features.get(i) + ",";
    content += this.classLabel + ",";
    content += this.highlighted;
    return content;
  }

}
