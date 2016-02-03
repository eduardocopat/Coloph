part of coloph;

class RelationshipView {
  Relationship relationship;
  BorderInteractionController borderInteractionController;
  
  BorderConnection bcnParentTableAndChildTable;
  BorderConnection bcnParentTableAndRelationship; 
  BorderConnection bcnChildTableAndRelationship;  
  BorderConnection bcnTernaryTableAndRelationship;
  int TOGGLE_SQUARE_SIZE = 5;
  
  bool toggled;
  bool highlighted;
  RelationshipField toggledRelationshipField;
  CanvasRenderingContext2D ctx;
  
  List<Line> relationshipLines;

  RelationshipView(CanvasRenderingContext2D ctx, Relationship relationship, BorderInteractionController borderInteractionController){
    this.relationship = relationship;
    this.ctx = ctx;
    this.borderInteractionController = borderInteractionController;
  }
  
  void updateRelationship(Relationship updatedRelationship){
    this.relationship = updatedRelationship;
  }

  setBorderConnections(BorderConnection bcnParentTableAndRelationship, BorderConnection bcnChildTableAndRelationship){
    this.bcnParentTableAndRelationship = bcnParentTableAndRelationship;
    this.bcnChildTableAndRelationship  = bcnChildTableAndRelationship;
  }
  
  setBorderConnection(BorderConnection bcnParentTableAndChildTable){
    this.bcnParentTableAndChildTable = bcnParentTableAndChildTable;
  }
  
  void glueRelationshipFields(){}
  void draw(){}
  void drawRelationshipName(bool enable){}
  
  void _drawToggleSquare(Point startPoint, Point endPoint){
      Point togglePoint; 
      
      num toggleX = (startPoint.x + endPoint.x)/2 - (TOGGLE_SQUARE_SIZE/2);
      num toggleY = (startPoint.y + endPoint.y)/2 - (TOGGLE_SQUARE_SIZE/2);
      togglePoint = new Point(toggleX, toggleY);
      
      ctx.beginPath();
      ctx.lineWidth = 2;
      ctx.rect(togglePoint.x, togglePoint.y, TOGGLE_SQUARE_SIZE , TOGGLE_SQUARE_SIZE);
      ctx.fillStyle = '#00FF00';
      ctx.fillRect(togglePoint.x, togglePoint.y, TOGGLE_SQUARE_SIZE , TOGGLE_SQUARE_SIZE);
      ctx.closePath();
      ctx.stroke();
      ctx.lineWidth = 1;
  }
  
  void toggle(bool toggle){
    if(toggle){
      toggled = true;
    }
    else
      toggled = false;
  }

}
