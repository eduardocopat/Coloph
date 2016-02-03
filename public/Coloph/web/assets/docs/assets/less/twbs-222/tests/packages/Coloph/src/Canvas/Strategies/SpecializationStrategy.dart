part of coloph;

/** This strategy is used when the user is setting a relationship between two tables **/
class SpecializationStrategy extends CanvasInteractionStrategy{
  
  CanvasRenderingContext2D ctx;
  TableController tableController;
  CanvasActionsController canvasActionsContorller;
  SpecializationController specializationController;
  DiagramController diagramController;
  CreationStatus creationStatus;
  
  Table parentTable;
  Table specializedTable;
  Table movedOverTable; //Table which the user is passingby the mouse
  
  
  SpecializationStrategy(CanvasRenderingContext2D ctx, 
     TableController tableController, 
     SpecializationController specializationController,
     DiagramController diagramController,
     CanvasActionsController canvasActionsContorller){
    this.ctx = ctx;
    this.tableController = tableController;
    this.specializationController = specializationController;
    this.diagramController = diagramController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.creationStatus =  new CreationStatus();
    ctx.canvas.style.cursor = 'crosshair';
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
     if(!creationStatus.hasStarted()){
        parentTable = tableController.getClickedTable(canvasMousePosition);
        //If it is hitting a table
        if(parentTable != null){
            tableController.highlightTable(parentTable, true);
            specializationController.createSpecializationDefinition(canvasMousePosition);
            creationStatus.setStarted();
        } else {
          canvasActionsContorller.setDefaultCanvasInteractionContext();
        }
     } else {
        specializedTable = tableController.getClickedTable(canvasMousePosition);
          if(specializedTable != null){
            if(parentTable != specializedTable){
              Specialization specialization = new Specialization(diagramController.getDiagramId(), parentTable, specializedTable);
              specializationController.newSpecialization(specialization);
              tableController.highlightTable(specializedTable, false);
          }
        }
        
        //Unhighlight and set the default stance
        tableController.highlightTable(parentTable, false);
       
        
        specializationController.deleteSpecializationDefinition();
        canvasActionsContorller.setDefaultCanvasInteractionContext();
      }
  }
    
  executeMouseMove(Point canvasMousePosition){
    if(creationStatus.hasStarted()){
      if(movedOverTable != null && !identical(movedOverTable, parentTable))
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
  }
  
  executeMouseUp(Point canvasMousePosition){
    //Table clickedTable = tableController.getClickedTable(canvasMousePosition);
    //if(clickedTable != null)
    //  tableController.highlightTable(clickedTable.id, false);
  }
  
}

class CreationStatus{
  bool status;
  
  CreationStatus(){
    status = false;
  }
  
  bool hasStarted(){
    return status;
  }
 
  
  void setStarted(){
    status = true;
  }
}