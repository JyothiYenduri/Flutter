class Option{
  int id;  
  int optionId;
  int choiceId;
  String optionNo;
  String optionImage;
  String optionManufacturer;
  String optionModel;
  String optionDisplayDesc;
  String optionPrintDesc;  
  String cutoffDate;
  String optionDropDate;
  String legendId;
  String legendCaption;
  String legendImage;
  String categoryCanOrder;
  String optionVideoCount;
  double price;
  Option({this.id,this.optionId,this.choiceId, this.optionNo, this.optionImage, this.optionManufacturer, this.optionModel,
  this.optionDisplayDesc, this.optionPrintDesc, this.cutoffDate, this.optionDropDate, this.legendId,this.legendCaption, 
  this.legendImage, this.categoryCanOrder, this.optionVideoCount, this.price});
}