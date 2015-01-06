public class SampleManager{

  private ArrayList<String> labels;
  private ArrayList<Sample> samples;

  public SampleManager(){
    this.labels = new ArrayList<String>();
    this.samples = new ArrayList<Sample>();
  }

  public void addLabel(String label){
    this.labels.add(label);
  }
  public void add(Sample sample){
    this.samples.add(sample);
  }

  public int getNumberOfLabels(){
    return this.labels.size();
  }
  public String getLabelAt(int index){
    return this.labels.get(index);
  }

  public float getMaxOf(int featureIndex){
    float max = MIN_FLOAT;
    for(int i = 0; i < this.samples.size(); i++){
      float value = this.samples.get(i).getFeatureAt(featureIndex);
      if(value > max)
        max = value;
    }
    return max;
  }
  public int getMaxOfClassLabel(){
    int max = MIN_INT;
    for(int i = 0; i < this.samples.size(); i++){
      int classLabel = this.samples.get(i).getClassLabel();
      if(classLabel > max)
        max = classLabel;
    }
    return max;
  }

  public int getNumberOfSamples(){
    return this.samples.size();
  }
  public Sample getSampleAt(int index){
    return this.samples.get(index);
  }

  public void dumpInfo(){
    for(int i = 0; i < this.labels.size(); i++)
      print(this.labels.get(i) + ",");
    println();
    for(int i = 0; i < this.samples.size(); i++)
      println(this.samples.get(i).toString());
  }

}
