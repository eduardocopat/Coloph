part of coloph;

class LogicalTableView extends TableView{
  bool onlyPrimaryKeys;
  bool noPrimaryKeys;
  
  num _tableFieldShifter;
  
  TableField blankPrimaryKeyTableField;
  TableField blankNormalTableField;
  
  LogicalTableView(CanvasRenderingContext2D ctx, Table table, BorderInteractionController borderInteractionController, TableController tableController) : super(ctx, table, borderInteractionController, tableController){
    blankPrimaryKeyTableField = new TableField(0,"", true, new ForeignKey(false,-1),"", false, false, false, false, null);
    blankNormalTableField = new TableField(0,"", false, new ForeignKey(false,-1), "",false, false, false, false, null);
    
    calcSizeProperties();
    updateFillingColorGradient();
  }

  void draw(){
    _tableFieldShifter = TABLE_HEADER_LINE;
    
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
    
    ctx.fillStyle = 'white';
    ctx.fillRect(table.x, table.y, table.width , table.height);
    ctx.stroke();

    _drawTableHeader();
    _drawTableName();
    
    //If there are no primary keys, draw a blank primary key field
    if(noPrimaryKeys){
      _drawTableField(blankPrimaryKeyTableField);          
    }
    else{
      //Draw the Primary keys block
      _drawTablePrimaryKeys();
      _drawForeignKeys();
    }
    
    _drawPrimaryKeySeperationLine();
    
    //If there are only primary keys, draw a blank normal field
    if(onlyPrimaryKeys){
      _drawTableField(blankNormalTableField);
    }
    else{
      //Draw the rest
      for(TableField tf in table.tableFields){
        if(tf.primaryKey == false)
          _drawTableField(tf);
      }
    }
    
    if(this.toggled == true)
      _toggle();
  }

  void _drawForeignKeys() {
    for(TableField tf in table.tableFields){
      if(tf.primaryKey == true && tf.foreignKey.value == true)
        _drawTableField(tf);
    }
  }

  void _drawTablePrimaryKeys() {
    for(TableField tf in table.tableFields){
      if(tf.primaryKey == true && tf.foreignKey.value == false)
        _drawTableField(tf);
    }
  }
  
  void _drawPrimaryKeySeperationLine(){
    ctx.beginPath();
    ctx.moveTo(table.x,table.y + TABLE_HEADER_SIZE + _tableFieldShifter + 2 );
    ctx.lineTo(table.x+table.width,table.y + TABLE_HEADER_SIZE + _tableFieldShifter + 2);
    ctx.closePath();
    ctx.stroke();
    _tableFieldShifter = _tableFieldShifter + SPACE_AFTER_SEPARATION_LINE ;
  }
  
  void _drawTableField(TableField tf){
    ctx.beginPath();
    if(tf.name != ""){
      
      String name;
      if(tf.foreignKey.value == true)
        name = "${tf.name} (FK)";
      else 
        name = tf.name;
      
      if(physical)
        name = name + " " + tf.dataType;
      
        ctx.fillText(name, table.x + _borderSize, table.y + TABLE_HEADER_CONSIDERATION + _tableFieldShifter );
    }
    ctx.stroke();
    ctx.closePath();
    _tableFieldShifter = _tableFieldShifter + SPACE_BETWEEN_FIELDS;
  }
  
  void _drawTableHeader(){
    ctx.beginPath();
    ctx.lineWidth = 0;
    ctx.rect(table.x, table.y, table.width , TABLE_HEADER_SIZE );
    ctx.fillStyle = tableNameGradient;
    ctx.fill();
    ctx.closePath();
    ctx.lineWidth = GOLDEN_RATIO;
    ctx.stroke();
  }
  
  /** Draws table name inside header */
  void _drawTableName(){
    ctx.fillStyle = 'black';
    num sizeTableName = ctx.measureText(table.name).width;
    num textXLocation = table.x + ( (table.width / 2) - (sizeTableName / 2));
    ctx.fillText(table.name,  textXLocation, table.y+14 );
    ctx.stroke();
  }
  
  /* Calculates the table's width and height, the primary key consideration
   * and the largest name size */
  void calcSizeProperties(){
    noPrimaryKeys = _isTherePrimaryKey() ? false : true;
    onlyPrimaryKeys = _isThereOnlyPrimaryKeys() ? true : false; 

    _calcLargestNameSize();
    table.width = _calcTableWidthSize();
    table.height = _calcTableHeightSize();
    
    _calcBorderSize(table.width);
  }

  num _calcTableWidthSize(){
    num largerSize;
    
    num tableNameSize = ctx.measureText(table.name).width;
    num largestTableFieldSize = _largestNameSize;
    
    if(tableNameSize > largestTableFieldSize)
      largerSize = tableNameSize;
    else
      largerSize = largestTableFieldSize;
    
    largerSize += GRID_SQUARE_SIZE + GRID_SQUARE_SIZE;
    
    //Rounds to match GRID_SQUARE_SIZE;
    largerSize = (largerSize / GRID_SQUARE_SIZE).round() * GRID_SQUARE_SIZE;
    
    return largerSize;
  }
  
   void _calcLargestNameSize(){
    _largestNameSize = 0;
    for(TableField tf in table.tableFields){
      num tableFieldNameSize = ctx.measureText(tf.name).width;
      
      if(tf.foreignKey.value == true)
        tableFieldNameSize += ctx.measureText(" (FK)").width;
      
      if(physical)
        tableFieldNameSize += ctx.measureText(tf.dataType).width;

      if(tableFieldNameSize > _largestNameSize)
        _largestNameSize = tableFieldNameSize;
    }
  }
   
  num _calcTableHeightSize(){
    //Starts with 15, the table header
    num size = TABLE_HEADER_SIZE;
    //then add + 10 for the first field
    size = size + 10;

    for(TableField tf in table.tableFields){
      size = size + SPACE_BETWEEN_FIELDS;
    }
    //If there are no primary key fields or only keyfields,
    //uses fake tableField, with null values to represent the area
    if(noPrimaryKeys || onlyPrimaryKeys)
      size = size + SPACE_BETWEEN_FIELDS;
      
    size = (size / GRID_SQUARE_SIZE).round() * GRID_SQUARE_SIZE;
    return size ;
  }
  
  bool _isTherePrimaryKey(){
    for(TableField tf in table.tableFields){
      if(tf.primaryKey == true)
        return true;
    }
    return false;
  }
  
  bool _isThereOnlyPrimaryKeys(){
    for(TableField tf in table.tableFields){
      if(tf.primaryKey == false)
        return false;
    }
    return true;
  }
  
  void _clearTableFields(){
    for(TableField tableField in table.tableFields){
      tableField.x = tableField.y = tableField.width = tableField.height = 1;
    }
  }
  
  void drawToggled(){
    
  }

  void updateFillingColorGradient(){
     tableNameGradient = null;
      tableNameGradient = ctx.createLinearGradient(table.x, table.y, table.x + table.width, table.y + TABLE_HEADER_SIZE);
      tableNameGradient.addColorStop(0, FILLING_TABLE_COLOR);
      tableNameGradient.addColorStop(1, FILLING_TABLE_COLOR_HEAVY); // \,,/
  }

}
