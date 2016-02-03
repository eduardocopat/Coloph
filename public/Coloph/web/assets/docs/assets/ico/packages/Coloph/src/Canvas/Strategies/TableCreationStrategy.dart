part of coloph;

/** This strategy is used when the user is creating a new table */
class TableCreationStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  TableController tableController;
  CanvasActionsController canvasActionsContorller;
  Table tableBeingCreated;
  Point initialTablePosition;
  Point initialMousePosition;
  Map tableFieldsPosition;
  TableCreationStrategy(CanvasRenderingContext2D ctx,
                        TableController tableController, 
                        CanvasActionsController canvasActionsContorller,
                        Table tableBeingCreated){ 
    this.ctx = ctx;
    this.tableController = tableController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.ctx.canvas.style.cursor = 'move';
    this.tableBeingCreated = tableBeingCreated; 
    
    initialTablePosition = new Point(tableBeingCreated.x, tableBeingCreated.y);
    initialMousePosition = new Point((tableBeingCreated.x + tableBeingCreated.width )/2,(tableBeingCreated.y + tableBeingCreated.height)/2);
    tableController.toggle(tableBeingCreated);
    
    tableFieldsPosition = new Map();
    //Populates a list with the coordinates position from table fields
    for(TableField tableField in tableBeingCreated.tableFields){
      tableFieldsPosition[tableField] = new Point(tableField.x, tableField.y);
      for(TableField subTableField in tableField.baseSubFields){
        tableFieldsPosition[subTableField] = new Point(subTableField.x, subTableField.y); 
      }
    }
  }
  
  void executeMouseDown(Point canvasMousePosition, int clickOrigin){
    canvasActionsContorller.setDefaultCanvasInteractionContext();
    //Update location
    tableController.updateTable(tableBeingCreated, tableBeingCreated.name);
  }
  
  void executeMouseMove(Point canvasMousePosition){
    
    tableController.drag(tableBeingCreated, initialTablePosition, initialMousePosition, canvasMousePosition);
    
    if(tableController.getViewType() == ViewFactory.CONCEPTUAL){
      for(TableField tableField in tableBeingCreated.tableFields){
        tableController.drag(tableField, tableFieldsPosition[tableField], initialMousePosition, canvasMousePosition);
        for(TableField subTableField in tableField.baseSubFields){
          tableController.drag(subTableField, tableFieldsPosition[subTableField], initialMousePosition, canvasMousePosition);
        }
      }
    }
  }
  
}