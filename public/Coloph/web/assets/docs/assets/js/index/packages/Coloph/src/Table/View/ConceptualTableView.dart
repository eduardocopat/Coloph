part of coloph;
//Rect
//left = x
//top = y
class ConceptualTableView extends TableView{
  Table table;
  Map baseFieldGluers;
  CanvasEllipseDrawer canvasEllipseDrawer;
  
  ConceptualTableView(CanvasRenderingContext2D ctx, Table table, BorderInteractionController borderInteractionController, TableController tableController) 
  :super(ctx, table, borderInteractionController, tableController){
    calcSizeProperties();
    updateFillingColorGradient();
    canvasEllipseDrawer = new CanvasEllipseDrawer(ctx);
    
    //Is this method in the wrong place? Should it be called outside?
    //May be related to undo/redo problems.
    glueTableFields();

  }
  
  void glueTableFields(){
    baseFieldGluers = new Map();
    BaseFieldGluer baseFieldGluer = new BaseFieldGluer(table, ctx, borderInteractionController);
    for(TableField tableField in table.tableFields){
      if(tableField.isForeignKey())
        continue;
      
      if(tableField.x == 0 && tableField.y == 0)
        baseFieldGluer.glue(tableField);
      else{
        baseFieldGluer.setBaseFieldSize(tableField);
        baseFieldGluer.createBorderConnection(tableField);
      }
      baseFieldGluers[table] = baseFieldGluer;
      
      if(tableField.baseSubFields.length != 0){
      BaseFieldGluer subBaseFieldGluer = new BaseFieldGluer(tableField, ctx, borderInteractionController);
        for(TableField subTableField in tableField.baseSubFields){
          if(subTableField.x == 0 && subTableField.y == 0)
            subBaseFieldGluer.glue(subTableField);
          else{
            subBaseFieldGluer.setBaseFieldSize(subTableField);
            subBaseFieldGluer.createBorderConnection(subTableField);
          }
          baseFieldGluers[tableField] = subBaseFieldGluer;
        }
      }
    }
  }
  
  void updateTable(Table updatedTable){
    table = updatedTable;
    
    baseFieldGluers.clear();
    bool tableFieldExists;
    BaseFieldGluer baseFieldGluer = new BaseFieldGluer(updatedTable, ctx, borderInteractionController);
    for(TableField tableField in table.tableFields){
      if(tableField.isForeignKey())
        continue;
      if(tableField.hasAPosition())
        baseFieldGluer.createBorderConnection(tableField);
      else
        baseFieldGluer.glue(tableField); 
      
      baseFieldGluers[table] = baseFieldGluer;
      
      if(tableField.baseSubFields.length != 0){
      BaseFieldGluer subBaseFieldGluer = new BaseFieldGluer(tableField, ctx, borderInteractionController);
        for(TableField subTableField in tableField.baseSubFields){
          if(subTableField.hasAPosition())
            subBaseFieldGluer.createBorderConnection(subTableField);
          else
            subBaseFieldGluer.glue(subTableField); 
          
          baseFieldGluers[tableField] = subBaseFieldGluer;
        }
      }
    }
  }
  
  calcSizeProperties(){
    _calcLargestNameSize();
    table.width = _calcTableWidthSize();
    table.height = _calcTableHeightSize();
    
    _calcBorderSize(table.width);
  }
  
  _calcTableWidthSize(){
    num largerSize = _largestNameSize;
    largerSize += GRID_SQUARE_SIZE + GRID_SQUARE_SIZE;
    
    // Rounds to match GRID_SQUARE_SIZE;
    largerSize = (largerSize / GRID_SQUARE_SIZE).round() * GRID_SQUARE_SIZE;
    return largerSize;
  }
  
  _calcTableHeightSize(){
    // As there is only the table name in the conceptual, make the height larger
    num size = TABLE_HEADER_SIZE * 2.5;
    // Rounds to match GRID_SQUARE_SIZE;
    size = (size / GRID_SQUARE_SIZE).round() * GRID_SQUARE_SIZE;
    return size;
  }
  
  _calcLargestNameSize(){
    // In the conceptual view, the name of the table will be the largest name, as there is only it inside the rect
    _largestNameSize = ctx.measureText(table.name).width;  
  }
  
  void draw(){
    
    ctx.lineWidth = 1;
    //_drawToggled();
    ctx.strokeStyle = 'black';
    ctx.lineWidth = GOLDEN_RATIO;
    
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
    for(TableField tableField in table.tableFields){
      if(tableField.isForeignKey())
        continue;
      _drawTableField(tableField);
      
      for(TableField subTableField in tableField.baseSubFields){
        _drawTableField(subTableField);
      }
    }
    
    //Stronger border
    ctx.beginPath();
    ctx.lineWidth = 1;
    ctx.closePath();
    ctx.stroke();
    
    _drawTableShadow();
    if(this.highlighted == true)
      ctx.strokeStyle = 'grey';
    else
      ctx.strokeStyle = 'black';
    
    ctx.lineWidth = GOLDEN_RATIO;
    ctx.fillStyle = "black";
    
    //Ignore comment: Double to make it trouble
    ctx.beginPath();
    ctx.rect(table.x, table.y, table.width , table.height);
    ctx.closePath();
    ctx.stroke();
    
    if(table.isWeakEntity()){
      ctx.lineWidth = 0.5;
      ctx.rect(table.x+3.5, table.y+3.5, table.width-7 , table.height-7);
      ctx.lineWidth = GOLDEN_RATIO;
    }
    
    updateFillingColorGradient();
    ctx.fillStyle = tableNameGradient; 
    
    ctx.fillRect(table.x, table.y, table.width , table.height);
    ctx.strokeRect(table.x, table.y, table.width , table.height);
    _drawTableName();
    
    drawToggled();
  }
  
  void drawToggled(){
    if(toggled == true)
      _toggle();
    
    if(toggledTableField != null){
      _toggleTableField();
    }
  }
  
  _toggleTableField(){
    List<Point> togglingPoints = new List<Point>();
    //North
    togglingPoints.add(new Point(toggledTableField.x + toggledTableField.width/2-2,toggledTableField.y-2));
    //East
    togglingPoints.add(new Point(toggledTableField.x-2,toggledTableField.y-2 + toggledTableField.height/2));
    //West
    togglingPoints.add(new Point(toggledTableField.x-2+toggledTableField.width,toggledTableField.y-2 + toggledTableField.height/2));
    //South
    togglingPoints.add(new Point(toggledTableField.x + toggledTableField.width/2-2,toggledTableField.y-2+toggledTableField.height));
    
    for(Point p in togglingPoints){
      ctx.lineWidth = 2;
      ctx.rect(p.x, p.y, 5 , 5);
      ctx.fillStyle = TOGGLE_COLOR;
      ctx.fillRect(p.x, p.y, 5 , 5);
      ctx.stroke();
      ctx.lineWidth = 1;
    }
  }
  
  void _drawTableField(TableField tableField){
    bool dashedBorder = false;
    canvasEllipseDrawer.draw(tableField.x+3,tableField.y+3,tableField.width,tableField.height, SHADOW_COLOR, SHADOW_COLOR, dashedBorder);
    if(tableField.derived)
      dashedBorder = true;
    canvasEllipseDrawer.draw(tableField.x,tableField.y,tableField.width,tableField.height, 'white', 'black', dashedBorder);
    
    if(tableField.multivalued)
      canvasEllipseDrawer.draw(tableField.x+3,tableField.y+3,tableField.width-6,tableField.height-6, 'white', 'black', dashedBorder);
    
    
    ctx.fillText(tableField.name, tableField.x+(BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE/2), tableField.y+BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE);
    ctx.stroke();
    if(tableField.primaryKey == true)
      _drawUnderline(tableField);
  }
  
  void _drawUnderline(TableField tableField){
    ctx.strokeStyle = 'black';
    ctx.lineWidth = 1;
    ctx.beginPath();
    num underlineFactor = (FONT_SIZE/5);
    num a = tableField.x+(BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE/2);
    num b = tableField.y+BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE+underlineFactor;
    a = a.toInt();
    b = b.toInt();
    num c = tableField.x+tableField.width-(BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE/2)+2;
    num d = tableField.y+BaseFieldGluer.EXTRA_SPACE_INSIDE_ELLIPSE+underlineFactor;
    c = c.toInt();
    d = d.toInt();
    ctx.moveTo(a,b);
    ctx.lineTo(c,d);
    ctx.closePath();
    ctx.stroke();
  }
  
  void _drawTableName(){
    ctx.fillStyle = 'black';
    num widthTableName = ctx.measureText(table.name).width;
    num textXLocation = table.x + ( (table.width / 2) - (widthTableName / 2));
    num textYLocation = table.y + ((table.height / 2)) + (FONT_SIZE/2); //5 = Half the font size
    ctx.fillText(table.name,  textXLocation, textYLocation);
    ctx.stroke();
  }
  

  
  void updateFillingColorGradient(){
    tableNameGradient = null;
    tableNameGradient = ctx.createLinearGradient(table.x, table.y, table.x + table.width, table.y + table.height);
    tableNameGradient.addColorStop(0, FILLING_TABLE_COLOR);
    tableNameGradient.addColorStop(1, FILLING_TABLE_COLOR_HEAVY); // \,,/
  }
}

