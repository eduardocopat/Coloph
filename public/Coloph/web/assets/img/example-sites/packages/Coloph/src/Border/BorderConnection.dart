part of coloph;

class BorderConnection{
  BaseCanvasModel canvasModelA;
  BaseCanvasModel canvasModelB;
  
  String borderCodeA;
  String borderCodeB;
  BorderPoint borderPointA;
  BorderPoint borderPointB;
  num angle;
  bool specialRelation;
  bool enforcedOppositeBorderForModelA;
  StreamController pointsUpdatedController;
  
  static const POINTS_UPDATED = "Points_updated";
  
  BorderConnection(BaseCanvasModel canvasModelA,BaseCanvasModel canvasModelB){
   this.canvasModelA = canvasModelA;
   this.canvasModelB = canvasModelB;
   this.specialRelation = false;
   this.pointsUpdatedController = new StreamController();
  }

  void setBorderCodes(String borderCodeA, String borderCodeB){
    this.borderCodeA = borderCodeA;
    this.borderCodeB = borderCodeB;
  }

  void setRelationshipPointsAndAngle(BorderPoint borderPointA,  BorderPoint borderPointB, num angle){
    this.borderPointA = borderPointA;
    this.borderPointB = borderPointB;
    this.angle = angle;
  }
  
  void clearBorderPointsAndAngle(){
    borderPointB = null;
    borderPointA = null;
    angle = null;
  }
  
  bool areBorderPointsDefined(){
    if(angle != null && borderPointA != null && borderPointB != null)
      return true;
    else
      return false;
  }
  
  void forceOppositeBorderForModelA(){
    enforcedOppositeBorderForModelA = true;
  }
  
  void triggerPointsUpdated(){
    pointsUpdatedController.add(POINTS_UPDATED);
  }
  
  Stream get pointsUpdated => pointsUpdatedController.stream;

}