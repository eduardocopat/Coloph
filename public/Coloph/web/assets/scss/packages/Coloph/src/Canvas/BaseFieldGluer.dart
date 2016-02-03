part of coloph;

class BaseFieldGluer {
  static const int EXTRA_SPACE_INSIDE_ELLIPSE = 20;
  static const int NUMBER_OF_FIELDS_PER_OUTER_BORDER = 8;
  static const int INITIAL_SCALE = 3;
  int fieldsIndex;
  int outerBorderScale;
  BaseCanvasModel glueObject;
  CanvasRenderingContext2D ctx;
  List<TableFieldGlue> tableFieldGlues; 
  BorderInteractionController borderInteractionController;
  
  BaseFieldGluer(BaseCanvasModel glueObject, CanvasRenderingContext2D ctx, BorderInteractionController borderInteractionController){
    this.glueObject = glueObject;
    this.ctx = ctx;
    this.borderInteractionController = borderInteractionController;
    tableFieldGlues = [];
    _resetFieldPositionIndexes();
  }
  
  glue(BaseField baseField){
      _setBaseFieldPosition(baseField);
    //If the next number exceeds the number of fields per outer border, creates a new outer border, larger.
    if(_doesNextIndexExceedsFieldsPerBorder())
      _expandOuterBorderScale();
    
    if(_baseFieldIntersectsAnother(baseField)){
      glue(baseField);
      return;    
    }
    createBorderConnection(baseField);
  }
  
  appendGlue(BaseField baseField){
    _setBaseFieldPosition(baseField);
    //If the next number exceeds the number of fields per outer border, creates a new outer border, larger.
    if(_doesNextIndexExceedsFieldsPerBorder())
      _expandOuterBorderScale();
    
    if(_baseFieldIntersectsAnother(baseField)){
      appendGlue(baseField);
      return;    
    }
    borderInteractionController.addCanvasModel(baseField);
    createBorderConnection(baseField);
  }
  
  unglue(BaseField baseField){
    _resetFieldPositionIndexes();
    _removeBaseFieldFromGlues(baseField);
  }
  
  updateGlueObject(BaseCanvasModel glueObject){
    this.glueObject = glueObject;
  }
  
  _removeBaseFieldFromGlues(BaseField baseField){
    TableFieldGlue tableFieldGlueToBeRemoved;
    for(TableFieldGlue tableFieldGlue in tableFieldGlues){
      if(tableFieldGlue.tableField.name == baseField.name)
        tableFieldGlueToBeRemoved = tableFieldGlue;
    }
    tableFieldGlues.remove(tableFieldGlueToBeRemoved);
  }
  
  _resetFieldPositionIndexes(){
    fieldsIndex = 0;
    outerBorderScale = INITIAL_SCALE;
  }
  
  
  _setBaseFieldPosition(BaseField baseField){
    
    /*
    if(baseField.hasAPosition()){
      baseField.width = ctx.measureText(baseField.name).width+EXTRA_SPACE_INSIDE_ELLIPSE;
      baseField.height = FONT_SIZE + EXTRA_SPACE_INSIDE_ELLIPSE;
      glueObject.updateCentralBorderPoints();
      
      return;
    }
    */
      
    
    Rectangle outerBorder =_createInnerBorder(outerBorderScale);
    glueObject.updateCentralBorderPoints();
    List<BorderPoint> borderPoints = glueObject.getCentralBorderPoints();
    BorderPoint tableSouthCentralBorderPoint;
    BorderPoint tableNorthCentralBorderPoint;
    BorderPoint tableWestCentralBorderPoint;
    BorderPoint tableEastCentralBorderPoint;
    for(BorderPoint bp in borderPoints){
      switch(bp.borderCode){
        case BorderPoint.EAST:
          tableEastCentralBorderPoint = bp;
          break;
        case BorderPoint.WEST:
          tableWestCentralBorderPoint = bp;
          break;
        case BorderPoint.NORTH:
          tableNorthCentralBorderPoint = bp;
          break;
        case BorderPoint.SOUTH:
          tableSouthCentralBorderPoint = bp;
          break;
      }
    }
    
    setBaseFieldSize(baseField);

    int outerBorderIndex = fieldsIndex % NUMBER_OF_FIELDS_PER_OUTER_BORDER;
    switch(outerBorderIndex){
      case 0: //Northwest  
        baseField.x = glueObject.x - baseField.width*2;
        baseField.y = outerBorder.top;
      break;
      case 1: //North
        baseField.x = tableNorthCentralBorderPoint.point.x- (baseField.width/2);
        baseField.y = outerBorder.top;
      break;
      case 2: //Northeast
        baseField.x = glueObject.x + glueObject.width*1.5;
        baseField.y = outerBorder.top;
      break;
      case 3: //East
        baseField.x = outerBorder.left + outerBorder.width;
        baseField.y = tableEastCentralBorderPoint.point.y - baseField.height/2;
      break;
      case 4: //Southeast
        baseField.x = tableSouthCentralBorderPoint.point.x + glueObject.width + (baseField.width/2);
        baseField.y = outerBorder.top + outerBorder.height - baseField.height;
      break;
      case 5: //South
        baseField.x = tableSouthCentralBorderPoint.point.x - (baseField.width/2);
        baseField.y = outerBorder.top + outerBorder.height - baseField.height;
      break;
      case 6: //Southwest
        baseField.x = tableSouthCentralBorderPoint.point.x - baseField.width - (baseField.width/2);
        baseField.y = outerBorder.top + outerBorder.height - baseField.height;
      break;
      case 7: //West 
        baseField.x = outerBorder.left - baseField.width;
        baseField.y = tableEastCentralBorderPoint.point.y - baseField.height/2;
      break;
    }
    
    fieldsIndex++;
  }

  void setBaseFieldSize(BaseField baseField) {
      baseField.width = ctx.measureText(baseField.name).width+EXTRA_SPACE_INSIDE_ELLIPSE;
    baseField.height = FONT_SIZE + EXTRA_SPACE_INSIDE_ELLIPSE;
  }
  
  Rectangle _createInnerBorder(int scale){
    num x = glueObject.x + glueObject.width * (1 - scale)/2; 
    num y = glueObject.y + glueObject.height * (1 - scale)/2;
    num width = glueObject.width * scale; 
    num height = glueObject.height * scale; 
    
    return new Rectangle(x,y,width,height);
  }
  
/* If the next number exceeds the number of fields per outer border, creates a new outer border, larger.*/
  bool _doesNextIndexExceedsFieldsPerBorder(){
    if(fieldsIndex % NUMBER_OF_FIELDS_PER_OUTER_BORDER == 0)
      return true;
    else
      return false;
  }
  
  void _expandOuterBorderScale(){
    outerBorderScale = outerBorderScale + 3;
  }
  
  bool _baseFieldIntersectsAnother(BaseField baseField){
    //Test this own object fields
    //Se isso aqui não fizer sentido, apaga esse método
    /*
    for(BaseField otherField in glueObject.getFields()){
      if(baseField != otherField){
        if(baseField.intersectsBaseCanvasModel(otherField))
          return true;          
      }
    }
    */
    
    if(borderInteractionController.isIntersecting(baseField))
      return true;
    else 
      return false;
    
  }
  createBorderConnection(BaseField baseField){
    BorderConnection bcn = borderInteractionController.createBorderConnection(glueObject, baseField);
    bcn.forceOppositeBorderForModelA();
    borderInteractionController.calculateConnectionsLocation();
    TableFieldGlue tableFieldGlue = new TableFieldGlue(bcn.borderPointA,bcn.borderPointB, baseField);
    tableFieldGlues.add(tableFieldGlue);

    _updateTableFieldGlue(tableFieldGlue, bcn.borderPointA, bcn.borderPointB);
    _registerPointsUpdated(tableFieldGlue, bcn);    
  }
  
  _updateTableFieldGlue(TableFieldGlue tableFieldGlue, BorderPoint tablePoint, BorderPoint tableFieldPoint){
    tableFieldGlue.tablePoint = tablePoint;
    tableFieldGlue.tableFieldPoint = tableFieldPoint;
  }
  
  void _registerPointsUpdated(TableFieldGlue tableFieldGlue, BorderConnection bcn){
    bcn.pointsUpdated.listen((_) =>
        _updateTableFieldGlue(tableFieldGlue, bcn.borderPointA, bcn.borderPointB)
    );
  }
}
//Teste
class TableFieldGlue{
  BorderPoint tablePoint;
  BorderPoint tableFieldPoint;
  TableField tableField;
  
  TableFieldGlue(BorderPoint tablePoint, BorderPoint tableFieldPoint, TableField tableField){
    this.tablePoint = tablePoint;
    this.tableFieldPoint = tableFieldPoint;
    this.tableField = tableField;
  }
  
  bool arePointsNull(){
    if(tablePoint != null && tableFieldPoint != null)
      return false;
    else
      return true;
  }
}

  
