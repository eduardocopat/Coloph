part of coloph;

class LogicalRelationshipView extends RelationshipView {
    Connector parentConnector;
    Connector childConnector;
    
    BorderPoint parentBorderPoint;
    BorderPoint childBorderPoint;
    Point glueStartRelation;
    Point glueFinishRelation;
    
    bool relationshipNameShallBeDrawn;
    
    LogicalRelationshipView(CanvasRenderingContext2D ctx, Relationship relationship, BorderInteractionController borderInteractionController)
                     :super(ctx,relationship,borderInteractionController){
      relationshipLines = [];
    }

    void draw(){
      relationshipLines.clear();
      
      parentBorderPoint = bcnParentTableAndChildTable.borderPointA;
      childBorderPoint  = bcnParentTableAndChildTable.borderPointB;
      //As the connectors definition is handled by events, the connectors could not be assigned yet
      //so we test if they're null
      if(parentBorderPoint == null || childBorderPoint == null)
        return;
      
      _setConnectors();

      Point glueStartRelation = parentConnector.getGluePoint();
      glueFinishRelation = childConnector.getGluePoint();
      
      Point togglePointStart = glueStartRelation;
      Point togglePointEnd = glueFinishRelation;
      
      //Draw line between connectors
      ctx.lineWidth = 1;
      ctx.strokeStyle = 'black';
      
      if(toggled){
        ctx.lineWidth = 2;
      }
      
      if(relationship.dataType == Relationship.NON_IDENTIFYING_RELATIONSHIP)
        _setDashed(true);
     
      //If it is a self-relationship
      if(relationship.parentTable == relationship.childTable){
        ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
        ctx.lineTo(glueStartRelation.x, glueStartRelation.y-15);
        
        ctx.moveTo(glueStartRelation.x, glueStartRelation.y-15);
        ctx.lineTo(glueFinishRelation.x, glueStartRelation.y-15);
        _addLine(new Point(glueStartRelation.x, glueStartRelation.y-15), new Point(glueFinishRelation.x, glueStartRelation.y-15));
        
        ctx.moveTo(glueFinishRelation.x, glueStartRelation.y-15);
        ctx.lineTo(glueFinishRelation.x, glueFinishRelation.y);
      }
      else{   
        num middleX = (glueStartRelation.x + glueFinishRelation.x)/2 - (TOGGLE_SQUARE_SIZE/2);
        num middleY = (glueStartRelation.y + glueFinishRelation.y)/2 - (TOGGLE_SQUARE_SIZE/2);
        middleY = middleY.round()-0.5;
        middleX = middleX.round()-0.5;
        glueStartRelation = new Point(glueStartRelation.x.round()-0.5, glueStartRelation.y.round()-0.5);
        glueFinishRelation = new Point(glueFinishRelation.x.round()-0.5, glueFinishRelation.y.round()-0.5); 
       
        //If connection is between east and west borders
        if((parentBorderPoint.borderCode == BorderPoint.EAST && childBorderPoint.borderCode == BorderPoint.WEST) ||
           (parentBorderPoint.borderCode == BorderPoint.WEST && childBorderPoint.borderCode == BorderPoint.EAST)){
            ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
            ctx.lineTo(middleX, glueStartRelation.y);
            _addLine(new Point(glueStartRelation.x, glueStartRelation.y), new Point(middleX, glueStartRelation.y));
            
            ctx.lineTo(middleX, glueFinishRelation.y);
            
            _addLine(new Point(middleX, glueStartRelation.y), new Point(middleX, glueFinishRelation.y));
            ctx.lineTo(glueFinishRelation.x, glueFinishRelation.y);
            _addLine(new Point(middleX, glueFinishRelation.y), new Point(glueFinishRelation.x, glueFinishRelation.y));
        }
        //If connection is between north and south borders
        else if((parentBorderPoint.borderCode == BorderPoint.NORTH && childBorderPoint.borderCode == BorderPoint.SOUTH) ||
                (parentBorderPoint.borderCode == BorderPoint.SOUTH && childBorderPoint.borderCode == BorderPoint.NORTH)){    
            ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
            ctx.lineTo(glueStartRelation.x, middleY);
            _addLine(new Point(glueStartRelation.x, glueStartRelation.y), new Point(glueStartRelation.x, middleY));
            ctx.lineTo(glueFinishRelation.x, middleY);
            _addLine(new Point(glueStartRelation.x, middleY), new Point(glueFinishRelation.x, middleY));
            ctx.lineTo(glueFinishRelation.x, glueFinishRelation.y);
            _addLine(new Point(glueFinishRelation.x, middleY), new Point(glueFinishRelation.x, glueFinishRelation.y));
        }
        else{
          ctx.moveTo(glueStartRelation.x,  glueStartRelation.y);
          ctx.lineTo(glueFinishRelation.x, glueStartRelation.y);
          _addLine(new Point(glueStartRelation.x,  glueStartRelation.y), new Point(glueFinishRelation.x, glueStartRelation.y));
          ctx.lineTo(glueFinishRelation.x, glueFinishRelation.y);
          _addLine(new Point(glueFinishRelation.x, glueStartRelation.y), new Point(glueFinishRelation.x, glueFinishRelation.y));
          
          togglePointStart = new Point(glueFinishRelation.x, glueStartRelation.y);
          togglePointEnd = togglePointStart;
        }
       }
      ctx.stroke();
      
      
      ctx.beginPath();
      ctx.lineWidth = 1;
      ctx.closePath();
      ctx.stroke();
      
      _setDashed(false);
      if(toggled)
        _drawToggleSquare(togglePointStart, togglePointEnd);
      
      if(relationshipNameShallBeDrawn)
        _drawRelationshipNameAboveLine(togglePointStart, togglePointEnd);
      
    }
    
    drawRelationshipName(bool enable){
      relationshipNameShallBeDrawn = enable;
    }

    void _drawRelationshipNameAboveLine(Point togglePointStart, Point togglePointEnd) {
      ctx.lineWidth = 1;
      ctx.fillStyle = 'black';
      ctx.strokeStyle = 'black';
      num toggleX = (togglePointStart.x + togglePointEnd.x)/2 +5 - ctx.measureText(relationship.name).width/2;
      num toggleY = (togglePointStart.y + togglePointEnd.y)/2-5;
      ctx.fillText(relationship.name,  toggleX, toggleY);
      ctx.stroke();
    }
    
    void _setConnectors(){
      if(relationship.dataType == Relationship.MANY_TO_MANY_RELATIONSHIP){
        parentConnector = new ConnectorMany(parentBorderPoint, ctx);
        childConnector  = new ConnectorMany(childBorderPoint, ctx);
      } else {
        if(relationship.nullAllowed == Relationship.ALLOW_NULLS)
          parentConnector = new ConnectorZeroOrOne(parentBorderPoint, ctx);
        else
          parentConnector = new ConnectorOne(parentBorderPoint, ctx);
        
        if(relationship.parentCardinality == Relationship.ZERO_OR_ONE)
          childConnector  = new ConnectorZeroOrOne(childBorderPoint, ctx);
        if(relationship.parentCardinality == Relationship.ZERO_OR_MANY)
          childConnector  = new ConnectorZeroOrMany(childBorderPoint, ctx);
        if(relationship.parentCardinality == Relationship.ONE_OR_MANY)
          childConnector = new ConnectorOneOrMany(childBorderPoint, ctx);
        if(relationship.parentCardinality == Relationship.ONLY_ONE)
          childConnector = new ConnectorOne(childBorderPoint, ctx);
          
      }
      parentConnector.draw();
      childConnector.draw();
    }
    
    void _addLine(Point start, Point end){
      relationshipLines.add(new Line(start, end));
    }
    
    void _setDashed(bool dashed){
      if(dashed){
        ctx.setLineDash([10]);
        ctx.lineDashOffset = 1;
      }
      else{
        ctx.setLineDash([]);
      }
    }
    
    void _drawToggleSquare(Point startPoint, Point endPoint){
        Point togglePoint;        
        num toggleX = (startPoint.x + endPoint.x)/2 - (TOGGLE_SQUARE_SIZE/2);
        num toggleY = (startPoint.y + endPoint.y)/2 - (TOGGLE_SQUARE_SIZE/2);
        togglePoint = new Point(toggleX-2, toggleY-2);
        
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
