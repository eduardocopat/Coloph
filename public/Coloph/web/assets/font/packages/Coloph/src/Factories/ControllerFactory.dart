part of coloph;

class ControllerFactory {
  List<BaseController> controllerList;
  TableController tableController;
  RelationshipController relationshipController;
  BorderInteractionController borderInteractionController;
  CanvasActionsController canvasActionsController;
  PreferencesController preferencesController;
  CommandController commandController;
  DiagramController diagramController;
  HTTPRequestController hTTPRequestController;
  
  TableViewFactory tableViewFactory;
  TableModalFactory tableModalFactory;
  RelationshipViewFactory  relationshipViewFactory;
  RelationshipModalFactory relationshipModalFactory;
  SpecializationViewFactory specializationViewFactory;
  SpecializationController specializationController;

  ControllerFactory(CanvasRenderingContext2D ctx, int diagramId){
    hTTPRequestController = new HTTPRequestController();
    diagramController = new DiagramController(diagramId);
    borderInteractionController = new BorderInteractionController();
    canvasActionsController = new CanvasActionsController(ctx);
    commandController = new CommandController();
    preferencesController = new PreferencesController(ctx.canvas);
    
    specializationViewFactory = new SpecializationViewFactory(ctx);
    specializationController = new SpecializationController(ctx, specializationViewFactory);
    
    relationshipViewFactory = new RelationshipViewFactory(ctx);
    relationshipModalFactory = new RelationshipModalFactory();
    relationshipController = new RelationshipController(ctx,relationshipViewFactory, relationshipModalFactory); //One day maybe I could create a setNeededFactories..
    
    tableViewFactory = new TableViewFactory(ctx);
    tableModalFactory = new TableModalFactory();
    tableController = new TableController(ctx, tableViewFactory, tableModalFactory); 
    controllerList = [];
    controllerList.add(tableController);
    controllerList.add(relationshipController);
    controllerList.add(borderInteractionController);
    controllerList.add(canvasActionsController);
    controllerList.add(preferencesController);
    controllerList.add(specializationController);
    controllerList.add(hTTPRequestController);
    controllerList.add(diagramController);
    this.setControllerFactories();
    this.setNeededControllers();
  }

  void setControllerFactories()
  {
    for(BaseController controller in controllerList)
    {
      controller.setControllerFactory(this);
    }
  }

  void setNeededControllers()
  {
    for(BaseController controller in controllerList)
    {
      controller.setRequiredControllers();
    }
  }

  TableController getTableController()
  {
    return this.tableController;
  }

  RelationshipController getRelationshipController()
  {
    return this.relationshipController;
  }

  BorderInteractionController getBorderInteractionController()
  {
    return this.borderInteractionController;
  }

  CanvasActionsController getCanvasActionsController()
  {
    return this.canvasActionsController;
  }
  
  CommandController getCommandController(){
    return this.commandController;
  }
 
  PreferencesController getPreferencesController(){
    return this.preferencesController;
  }
  
  SpecializationController getSpecializationController(){
    return this.specializationController;
  }
  
  DiagramController getDiagramController(){
    return this.diagramController;
  }
  
  HTTPRequestController getHTTPRequestController(){
    return this.hTTPRequestController;
  }

  setConceptual(){
    borderInteractionController.clearConnections();
    tableViewFactory.setConceptualViews();
    tableModalFactory.setConceptualModal();
    relationshipViewFactory.setConceptualViews();
    relationshipModalFactory.setConceptualModal();
    specializationViewFactory.setConceptualViews();
    borderInteractionController.calculateConnectionsLocation();
  }
  
  setLogical(){
    borderInteractionController.clearConnections();
    tableViewFactory.setLogicalViews();
    tableModalFactory.setLogicalModal();
    relationshipViewFactory.setLogicalViews();
    relationshipModalFactory.setLogicalModal();
    specializationViewFactory.setLogicalViews();
    borderInteractionController.calculateConnectionsLocation();
  }
}
