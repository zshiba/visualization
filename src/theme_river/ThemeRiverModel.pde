public class ThemeRiverModel{

  private String xTitle;
  private String[] xLabels;
  private String[] yTitles;
  private float[][] values;

  public ThemeRiverModel(String xTitle, String[] xLabels, String[] yTitles, float[][] values){
    this.xTitle = xTitle;
    this.xLabels = xLabels;
    this.yTitles = yTitles;
    this.values = values;
//this.dumpInfo();
  }

  public String getXTitle(){
    return this.xTitle;
  }
  public String[] getXLabels(){
    return this.xLabels;
  }
  public int getNumberOfXLabels(){
    return this.xLabels.length;
  }
  public String[] getYTitles(){
    return this.yTitles;
  }
  public int getNumberOfValueRow(){
    return this.values.length;
  }
  public int getNumberOfValueColumn(){
    return this.values[0].length;
  }
  public float getValueAt(int row, int column){
    return this.values[row][column];
  }

  private void dumpInfo(){
    print(this.xTitle + ",");
    for(int i = 0; i < this.xLabels.length; i++)
      print(this.xLabels[i] + ",");
    println();
    for(int i = 0; i < this.values.length; i++){
      print(this.yTitles[i] + ",");
      for(int j = 0; j < this.values[i].length; j++)
        print(this.values[i][j] + ",");
      println();
    }
  }

}
