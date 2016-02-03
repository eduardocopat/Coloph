part of coloph;

abstract class TableView extends BaseView{
  BorderInteractionController borderInteractionController;
  bool physical;
  Table table;
  bool highlighted;
  num _largestNameSize;
  num _borderSize;
  CanvasGradient tableNameGradient;
  TableField toggledTableField;
  TableController tableController;
  
  int TOGGLE_SQUARE_SIZE = 5;
  num TABLE_HEADER_LINE = 3;
  num SPACE_BETWEEN_FIELDS = GRID_SQUARE_SIZE;
  num TABLE_HEADER_CONSIDERATION = 30;
  num TABLE_HEADER_SIZE = 19;
  num SPACE_AFTER_SEPARATION_LINE = 5;
  
  TableView(CanvasRenderingContext2D ctx, Table table, BorderInteractionController borderInteractionController,  TableController tableController){
    this.table = table;
    this.highlighted = false;
    this.toggled = false;
    this.ctx = ctx;
    this.borderInteractionController = borderInteractionController;
    this.tableController = tableController;
    table.updateCentralBorderPoints(); 
  }
  
  void updateTable(Table updatedTable){
    this.table = updatedTable;
  }
  
  void draw();
  void drawToggled();
  void calcSizeProperties();
  void calcFieldsPosition(){}
  void updateFillingColorGradient();
  void _calcLargestNameSize();
  num _calcTableWidthSize();
  num _calcTableHeightSize();
  
  num _calcBorderSize(int tableWidth){
    _borderSize = (tableWidth - _largestNameSize) / 2;
  }
  
  void _toggle(){
    ctx.strokeStyle = 'black';
    ctx.lineWidth = 1;
    List<Point> togglingPoints = new List<Point>();
    togglingPoints.add(new Point(table.x-2,table.y-2));
    togglingPoints.add(new Point(table.x+table.width-2,table.y-2));
    togglingPoints.add(new Point(table.x-2,table.y+table.height-2));
    togglingPoints.add(new Point(table.x+table.width-2,table.y+table.height-2));
    
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
  
  void _drawTableShadow(){
    ctx.strokeStyle = SHADOW_COLOR;
    ctx.rect(table.x+3, table.y+3, table.width , table.height);
    ctx.fillStyle = SHADOW_COLOR;
    ctx.fillRect(table.x+3, table.y+3, table.width , table.height);
    ctx.stroke();
  }
  
  void setPhysical(bool physical){
    this.physical = physical;
    calcSizeProperties();
  }
  
  
  
}

