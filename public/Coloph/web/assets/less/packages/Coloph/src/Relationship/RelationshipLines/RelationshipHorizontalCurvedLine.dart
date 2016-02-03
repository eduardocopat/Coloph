part of coloph;

class RelationshipHorizontalCurvedLine implements RelationshipLine{
  Point glueStartRelation;
  Point glueFinishRelation;
  
  RelationshipCurvedLine(Point glueStartRelation,Point glueFinishRelation){
    this.glueStartRelation = glueStartRelation;
    this.glueFinishRelation = glueFinishRelation;
  }
  
  void draw(){
    
  }
}