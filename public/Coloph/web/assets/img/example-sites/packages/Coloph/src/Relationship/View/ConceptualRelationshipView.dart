part of coloph;

class ConceptualRelationshipView extends RelationshipView {
  Point middlePoint;
  Map baseFieldGluers;
  num nameWidth;
  CanvasEllipseDrawer canvasEllipseDrawer;
  CanvasGradient diamondGradient;
  
    ConceptualRelationshipView(CanvasRenderingContext2D ctx, Relationship relationship, BorderInteractionController borderInteractionController)
    :super(ctx,relationship, borderInteractionController){
      canvasEllipseDrawer = new CanvasEllipseDrawer(ctx);
      updateFillingColorGradient();
      relationship.updateCentralBorderPoints();
    }
    
    void glueRelationshipFields(){
      baseFieldGluers = new Map();
      BaseFieldGluer baseFieldGluer = new BaseFieldGluer(relationship, ctx, borderInteractionController);
      for(RelationshipField relationshipField in relationship.relationshipFields){
        
        if(relationshipField.x == 0 && relationshipField.y == 0)
          baseFieldGluer.glue(relationshipField);
        else{
          baseFieldGluer.setBaseFieldSize(relationshipField);
          baseFieldGluer.createBorderConnection(relationshipField);
        }
        
        baseFieldGluers[relationship] = baseFieldGluer;
        
        if(relationshipField.baseSubFields.length != 0){
          BaseFieldGluer subBaseFieldGluer = new BaseFieldGluer(relationshipField, ctx, borderInteractionController);
          for(RelationshipField subRelationshipField in relationshipField.baseSubFields){
            subBaseFieldGluer.glue(subRelationshipField);
            
            if(subRelationshipField.x == 0 && subRelationshipField.y == 0)
              subBaseFieldGluer.glue(subRelationshipField);
            else{
              subBaseFieldGluer.setBaseFieldSize(subRelationshipField);
              subBaseFieldGluer.createBorderConnection(subRelationshipField);
            }
            baseFieldGluers[relationshipField] = subBaseFieldGluer;
          }
        }
      }
    }
    
    void updateRelationship(Relationship updatedRelationship){
      this.relationship = updatedRelationship;
    }

    void draw(){
      num nameWidth = ctx.measureText(relationship.name).width;
      Point glueStartRelation = new Point(bcnParentTableAndRelationship.borderPointA.point.x, bcnParentTableAndRelationship.borderPointA.point.y);
      Point glueFinishRelation = new Point(bcnChildTableAndRelationship.borderPointA.point.x, bcnChildTableAndRelationship.borderPointA.point.y);
      Point glueTernaryRelation;
      
      Map<String,Point> diamond = relationship.nameDiamond;
      Point middlePoint = relationship.nameDiamondMiddlePoint;
      
      //Draw line between connectors
      ctx.lineWidth = GOLDEN_RATIO;
      ctx.strokeStyle = 'black';
      
      if(relationship.dataType == Relationship.SELF_RELATIONSHIP){
        String parentCardinalityAndRole = "${relationship.parentCardinality} ${relationship.parentRole}"; 
        String childCardinalityAndRole = "${relationship.childCardinality} ${relationship.childRole}";
        switch(bcnParentTableAndRelationship.borderPointA.borderCode){
          case BorderPoint.NORTH:
            ctx.beginPath();
            ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
            ctx.lineTo(diamond[BorderPoint.EAST].x, diamond[BorderPoint.EAST].y-1);
            ctx.closePath();
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(glueFinishRelation.x, glueFinishRelation.y);
            ctx.lineTo(diamond[BorderPoint.WEST].x, diamond[BorderPoint.WEST].y);
            ctx.closePath();
            ctx.stroke();
            //Cardinality
            _drawCardinality(parentCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.EAST].x,diamond[BorderPoint.EAST].y+60));
            _drawCardinality(childCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.WEST].x-20,diamond[BorderPoint.WEST].y+60));
            break;
          case BorderPoint.SOUTH:
            ctx.beginPath();
            ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
            ctx.lineTo(diamond[BorderPoint.EAST].x, diamond[BorderPoint.EAST].y-1);
            ctx.closePath();
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(glueFinishRelation.x, glueFinishRelation.y);
            ctx.lineTo(diamond[BorderPoint.WEST].x, diamond[BorderPoint.WEST].y);
            ctx.closePath();
            ctx.stroke();
            //Cardinality
            _drawCardinality(parentCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.EAST].x,diamond[BorderPoint.EAST].y-50));
            _drawCardinality(childCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.WEST].x-20,diamond[BorderPoint.WEST].y-40));
          break;
          case BorderPoint.WEST:
            ctx.beginPath();
            ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
            ctx.lineTo(diamond[BorderPoint.NORTH].x, diamond[BorderPoint.NORTH].y-1);
            ctx.closePath();
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(glueFinishRelation.x, glueFinishRelation.y);
            ctx.lineTo(diamond[BorderPoint.SOUTH].x, diamond[BorderPoint.SOUTH].y);
            ctx.closePath();
            ctx.stroke();
            //Cardinality
            _drawCardinality(parentCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.SOUTH].x-40,diamond[BorderPoint.SOUTH].y+40));
            _drawCardinality(childCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.NORTH].x-40,diamond[BorderPoint.NORTH].y-40));
          break;
          case BorderPoint.EAST:
            ctx.beginPath();
            ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
            ctx.lineTo(diamond[BorderPoint.NORTH].x, diamond[BorderPoint.NORTH].y-1);
            ctx.closePath();
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(glueFinishRelation.x, glueFinishRelation.y);
            ctx.lineTo(diamond[BorderPoint.SOUTH].x, diamond[BorderPoint.SOUTH].y);
            ctx.closePath();
            ctx.stroke();
            //Cardinality
            _drawCardinality(parentCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.SOUTH].x,diamond[BorderPoint.SOUTH].y+40));
            _drawCardinality(childCardinalityAndRole, middlePoint, new Point(diamond[BorderPoint.NORTH].x-40,diamond[BorderPoint.NORTH].y-40));
          break;
        }
      }else{
      //parent to relationship
        ctx.beginPath();

        ctx.moveTo(glueStartRelation.x, glueStartRelation.y);
        switch(bcnParentTableAndRelationship.borderPointA.borderCode){
          case BorderPoint.NORTH:
            ctx.lineTo(diamond[BorderPoint.SOUTH].x, diamond[BorderPoint.SOUTH].y);
          break;
          case BorderPoint.SOUTH:
            ctx.lineTo(diamond[BorderPoint.NORTH].x, diamond[BorderPoint.NORTH].y);
          break;
          case BorderPoint.WEST:
            ctx.lineTo(diamond[BorderPoint.EAST].x, diamond[BorderPoint.EAST].y-1);
          break;
          case BorderPoint.EAST:
            ctx.lineTo(diamond[BorderPoint.WEST].x, diamond[BorderPoint.WEST].y);
          break;
        }
        ctx.closePath();
        ctx.stroke();
        
        //child to relationship
        ctx.beginPath();
        ctx.moveTo(glueFinishRelation.x, glueFinishRelation.y);
        switch(bcnChildTableAndRelationship.borderPointA.borderCode){
          case BorderPoint.NORTH:
            ctx.lineTo(diamond[BorderPoint.SOUTH].x, diamond[BorderPoint.SOUTH].y);
          break;
          case BorderPoint.SOUTH:
            ctx.lineTo(diamond[BorderPoint.NORTH].x, diamond[BorderPoint.NORTH].y);
          break;
          case BorderPoint.WEST:
            ctx.lineTo(diamond[BorderPoint.EAST].x, diamond[BorderPoint.EAST].y);
          break;
          case BorderPoint.EAST:
            ctx.lineTo(diamond[BorderPoint.WEST].x, diamond[BorderPoint.WEST].y);
          break;
        }
      
        ctx.closePath();
        ctx.stroke();
        
        //ternary to relationship
        
        if(bcnTernaryTableAndRelationship != null){
          glueTernaryRelation = new Point(bcnTernaryTableAndRelationship.borderPointA.point.x, bcnTernaryTableAndRelationship.borderPointA.point.y);
          ctx.beginPath();
          ctx.moveTo(glueTernaryRelation.x, glueTernaryRelation.y);
          switch(bcnTernaryTableAndRelationship.borderPointA.borderCode){
            case BorderPoint.NORTH:
              ctx.lineTo(diamond[BorderPoint.SOUTH].x, diamond[BorderPoint.SOUTH].y);
              break;
            case BorderPoint.SOUTH:
              ctx.lineTo(diamond[BorderPoint.NORTH].x, diamond[BorderPoint.NORTH].y);
              break;
            case BorderPoint.WEST:
              ctx.lineTo(diamond[BorderPoint.EAST].x, diamond[BorderPoint.EAST].y);
              break;
            case BorderPoint.EAST:
              ctx.lineTo(diamond[BorderPoint.WEST].x, diamond[BorderPoint.WEST].y);
              break;
          }
          ctx.closePath();
          ctx.stroke();
        }
        
        //Cardinality     
        _drawCardinality(relationship.parentCardinality, middlePoint, glueFinishRelation);
        _drawCardinality(relationship.childCardinality, middlePoint, glueStartRelation);
        if(bcnTernaryTableAndRelationship != null){
          _drawCardinality(relationship.ternaryCardinality, middlePoint, glueTernaryRelation);
        }
        
      }
      
      List<BaseFieldGluer> baseFieldGluersList = baseFieldGluers.values;
      for(BaseFieldGluer baseFieldgluer in baseFieldGluersList){
        for(TableFieldGlue tableFieldGlue in baseFieldgluer.tableFieldGlues){
          if(!tableFieldGlue.arePointsNull()){
            ctx.beginPath();
            ctx.moveTo((tableFieldGlue.tablePoint.point.x).toInt(), (tableFieldGlue.tablePoint.point.y).toInt());
            ctx.lineTo((tableFieldGlue.tableFieldPoint.point.x).toInt(), (tableFieldGlue.tableFieldPoint.point.y).toInt());
            ctx.closePath();
            ctx.stroke();
          }
        }
      }
      
      for(RelationshipField relationshipField in relationship.relationshipFields){
        _drawRelationshipField(relationshipField);
        
        for(RelationshipField relationshipField in relationshipField.baseSubFields){
          _drawRelationshipField(relationshipField);
        }
      }
      
     _drawDiamondShadow(diamond);
     _drawDiamond(diamond, GOLDEN_RATIO);
     if(relationship.identifying){
       Map<String,Point> identifyingDiamond = _createIdentifyingDiamond(diamond);
       _drawDiamond(identifyingDiamond, 0.5);
       
     }
     _drawNameInDiamond(middlePoint, nameWidth);

   
 
     ctx.lineWidth = 1;
     ctx.fillStyle = 'black';
     ctx..font = FONT_TYPE_AND_SIZE;
     ////////////////
    
      //Stronger border
      ctx.beginPath();
      ctx.lineWidth = 1;
      ctx.closePath();
      ctx.stroke();
      ctx.lineWidth = 1;
      
      if(toggled)
        _toggle();
      if(toggledRelationshipField != null){
        _toggleTableField();
      }
   }
    
   Map<String,Point> _createIdentifyingDiamond(Map<String,Point> diamond){
     Map<String,Point> identifyingDiamond = new Map<String,Point>();
     identifyingDiamond[BorderPoint.SOUTH] = new Point(diamond[BorderPoint.SOUTH].x,diamond[BorderPoint.SOUTH].y-(relationship.height*0.15));
     identifyingDiamond[BorderPoint.NORTH] = new Point(diamond[BorderPoint.NORTH].x, diamond[BorderPoint.NORTH].y+(relationship.height*0.15));
     identifyingDiamond[BorderPoint.EAST]  = new Point(diamond[BorderPoint.EAST].x-(relationship.width*0.15), diamond[BorderPoint.EAST].y);
     identifyingDiamond[BorderPoint.WEST]  = new Point(diamond[BorderPoint.WEST].x+(relationship.width*0.15), diamond[BorderPoint.WEST].y);
     return identifyingDiamond;
  }
    
  void _drawCardinality(String cardinalityDisplay, Point middlePoint, Point glueRelation){
    ctx.beginPath();
    ctx.strokeStyle = '#F8F8F8';
    ctx.fillStyle = '#F8F8F8';
    num width = ctx.measureText(cardinalityDisplay).width;
    
    Point pointInLine = pointFromEndOfLine(middlePoint, glueRelation, 30);
    ctx.rect(pointInLine.x-10, pointInLine.y-10, width, 14);
    ctx.fillRect(pointInLine.x-10, pointInLine.y-10, width, 14);
    ctx.closePath();
    ctx.stroke();
    
    ctx.lineWidth = 1;
    ctx.fillStyle = 'black';
    ctx.strokeStyle = 'black';
    ctx.fillText(cardinalityDisplay, pointInLine.x-10 , pointInLine.y );
  }
    
    void _drawRelationshipField(RelationshipField relationshipField){
      bool dashedBorder = false;
      canvasEllipseDrawer.draw(relationshipField.x+3,relationshipField.y+3,relationshipField.width,relationshipField.height, SHADOW_COLOR, SHADOW_COLOR,dashedBorder);
      canvasEllipseDrawer.draw(relationshipField.x,relationshipField.y,relationshipField.width,relationshipField.height, 'white', 'black',dashedBorder);
      
      ctx.fillText(relationshipField.name, relationshipField.x+(BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE/2), relationshipField.y+BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE);
      ctx.stroke();
      
      if(relationshipField.primaryKey == true)
        _drawUnderline(relationshipField);
    }
    
    void _drawDiamond(Map<String,Point> diamond, num lineWidth){
      if(highlighted)
        ctx.strokeStyle = 'grey';
      else
        ctx.strokeStyle = 'black';
      ctx.lineWidth = lineWidth;
      ctx.beginPath();
      ctx.moveTo(diamond[BorderPoint.NORTH].x.toInt(), diamond[BorderPoint.NORTH].y.toInt());
      ctx.lineTo(diamond[BorderPoint.WEST] .x.toInt(), diamond[BorderPoint.WEST] .y.toInt());
      ctx.lineTo(diamond[BorderPoint.SOUTH].x.toInt(), diamond[BorderPoint.SOUTH].y.toInt());
      ctx.lineTo(diamond[BorderPoint.EAST] .x.toInt(), diamond[BorderPoint.EAST] .y.toInt());
      ctx.closePath();
      ctx.stroke();
      updateFillingColorGradient();
      ctx.fillStyle = diamondGradient; 
      ctx.fill();
      
    }
    
    void _drawUnderline(RelationshipField relationshipField){
       ctx.strokeStyle = 'black';
       ctx.lineWidth = 1;
       ctx.beginPath();
       num underlineFactor = (FONT_SIZE/5);
       num a = relationshipField.x+(BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE/2);
       num b = relationshipField.y+BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE+underlineFactor;
       a = a.toInt();
       b = b.toInt();
       num c = relationshipField.x+relationshipField.width-(BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE/2)+2;
       num d = relationshipField.y+BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE+underlineFactor;
       c = c.toInt();
       d = d.toInt();
       ctx.moveTo(a,b);
       ctx.lineTo(c,d);
       ctx.closePath();
       ctx.stroke();
     }
    
    void _drawNameInDiamond(Point middlePoint, num nameWidth){
      ctx.fillStyle = 'black';
      num textXLocation = middlePoint.x - nameWidth/2;
      num textYLocation = middlePoint.y + FONT_SIZE/2;
      ctx.fillText(relationship.name,  textXLocation, textYLocation);
      ctx.stroke();
    }
    
    void _drawToggleSquare(Point startPoint, Point endPoint){
      Point togglePoint; 
      const TOGGLE_SQUARE_SIZE = 5;
      
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
    
    void _toggle(){
      List<Point> togglingPoints = new List<Point>();
      togglingPoints.add(new Point(relationship.nameDiamond[BorderPoint.NORTH].x-2,relationship.nameDiamond[BorderPoint.NORTH].y-2));
      togglingPoints.add(new Point(relationship.nameDiamond[BorderPoint.WEST].x-2,relationship.nameDiamond[BorderPoint.WEST].y-2));
      togglingPoints.add(new Point(relationship.nameDiamond[BorderPoint.SOUTH].x-2,relationship.nameDiamond[BorderPoint.SOUTH].y-2));
      togglingPoints.add(new Point(relationship.nameDiamond[BorderPoint.EAST].x-2,relationship.nameDiamond[BorderPoint.EAST].y-2));
      
      for(Point p in togglingPoints){
        ctx.beginPath();
        ctx.lineWidth = 2;
        ctx.rect(p.x, p.y, 5 , 5);
        ctx.fillStyle = TOGGLE_COLOR;
        ctx.fillRect(p.x, p.y, 5 , 5);
        ctx.closePath();
        ctx.stroke();
        ctx.lineWidth = 1;
      }
    }
    
    _toggleTableField(){
      List<Point> togglingPoints = new List<Point>();
      //North
      togglingPoints.add(new Point(toggledRelationshipField.x + toggledRelationshipField.width/2-2,toggledRelationshipField.y-2));
      //East
      togglingPoints.add(new Point(toggledRelationshipField.x-2,toggledRelationshipField.y-2 + toggledRelationshipField.height/2));
      //West
      togglingPoints.add(new Point(toggledRelationshipField.x-2+toggledRelationshipField.width,toggledRelationshipField.y-2 + toggledRelationshipField.height/2));
      //South
      togglingPoints.add(new Point(toggledRelationshipField.x + toggledRelationshipField.width/2-2,toggledRelationshipField.y-2+toggledRelationshipField.height));
      
      for(Point p in togglingPoints){
        ctx.beginPath();
        ctx.lineWidth = 2;
        ctx.rect(p.x, p.y, 5 , 5);
        ctx.fillStyle = TOGGLE_COLOR;
        ctx.fillRect(p.x, p.y, 5 , 5);
        ctx.closePath();
        ctx.stroke();
        ctx.lineWidth = 1;
      }
    }
    
    void _drawDiamondShadow(Map<String,Point> diamond){
      ctx.strokeStyle = SHADOW_COLOR;
      ctx.beginPath();
      ctx.moveTo(diamond[BorderPoint.NORTH].x.toInt()+3, diamond[BorderPoint.NORTH].y.toInt()+3);
      ctx.lineTo(diamond[BorderPoint.WEST] .x.toInt()+3, diamond[BorderPoint.WEST] .y.toInt()+3);
      ctx.lineTo(diamond[BorderPoint.SOUTH].x.toInt()+3, diamond[BorderPoint.SOUTH].y.toInt()+3);
      ctx.lineTo(diamond[BorderPoint.EAST] .x.toInt()+3, diamond[BorderPoint.EAST] .y.toInt()+3);
      ctx.closePath();
      ctx.stroke();
      ctx.fillStyle = SHADOW_COLOR; 
      ctx.fill();
      ctx.strokeStyle = 'black';
    }
    
    void updateFillingColorGradient(){
      diamondGradient = null;
      diamondGradient = ctx.createLinearGradient(relationship.x, relationship.y, relationship.x + relationship.width, relationship.y + relationship.height);
      diamondGradient.addColorStop(0, FILLING_RELATIONSHIP_COLOR);
      diamondGradient.addColorStop(1, FILLING_RELATIONSHIP_COLOR_HEAVY); // \,,/
    }
}
