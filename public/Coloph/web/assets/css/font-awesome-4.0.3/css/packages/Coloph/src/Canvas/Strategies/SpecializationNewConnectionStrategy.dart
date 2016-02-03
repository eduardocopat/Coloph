part of coloph;

/** This strategy is used when the user is setting a relationship between two tables **/
class SpecializationNewConnectionStrategy extends CanvasInteractionStrategy{
  
  CanvasRenderingContext2D ctx;
  TableController tableController;
  CanvasActionsController canvasActionsContorller;
  SpecializationController specializationController;
  
  Specialization clickedSpecialization;
  Table specializedTable;
  Table movedOverTable; //Table which the user is passingby the mouse
  Table lastTable;
  
  
  SpecializationNewConnectionStrategy(CanvasRenderingContext2D ctx, 
     TableController tableController, 
     SpecializationController specializationController,
     CanvasActionsController canvasActionsContorller,
     Specialization clickedSpecialization,
     Point canvasMousePosition){
    this.ctx = ctx;
    this.tableController = tableController;
    this.specializationController = specializationController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.clickedSpecialization = clickedSpecialization;
    ctx.canvas.style.cursor = 'crosshair';
    
    specializationController.highlightSpecialization(clickedSpecialization);
    specializationController.createSpecializationDefinition(canvasMousePosition);
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
    specializedTable = tableController.getClickedTable(canvasMousePosition);
    specializationController.highlightSpecialization(clickedSpecialization, true);
    
    if(specializedTable != null){
      specializationController.updateSpecialization(clickedSpecialization, specializedTable);
      tableController.highlightTable(specializedTable, false);
      specializationController.highlightSpecialization(clickedSpecialization, false);
    }
      
    specializationController.deleteSpecializationDefinition();
    canvasActionsContorller.setDefaultCanvasInteractionContext();
      
  }
    
  executeMouseMove(Point canvasMousePosition){
    if(movedOverTable != null)
      tableController.highlightTable(movedOverTable, false);
    
    movedOverTable = tableController.getClickedTable(canvasMousePosition);
    //Am I moving above a table?
    if(movedOverTable != null){
      //Highlight this then!!
      tableController.highlightTable(movedOverTable, true);
    } else {  
      //Have I moved another table before? I need unhighlight it!
     
    }
    specializationController.setSpecializationDefinitionEndPoint(canvasMousePosition);
  }
  
  executeMouseUp(Point canvasMousePosition){
    //Table clickedTable = tableController.getClickedTable(canvasMousePosition);
    //if(clickedTable != null)
    //  tableController.highlightTable(clickedTable.id, false);
  }
  
}