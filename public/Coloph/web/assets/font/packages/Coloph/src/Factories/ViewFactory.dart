part of coloph;

abstract class ViewFactory{
  CanvasRenderingContext2D ctx;
  bool logicalViews;
  bool conceptualViews;
  static const String CONCEPTUAL = "conceptual";
  static const String LOGICAL = "logical";
  
  void setLogicalViews();
  void setConceptualViews();
  void recreateViews();
  
  String getViewType(){
    if(logicalViews)
      return ViewFactory.LOGICAL;
    if(conceptualViews)
      return ViewFactory.CONCEPTUAL;
  }
}

