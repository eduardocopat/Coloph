part of coloph;

/** This strategy is triggered when a table is right clicked in the canvas **/
class SpecializationCanvasMenuStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  SpecializationController specializationController;
  TableController tableController;
  CanvasActionsController canvasActionsContorller;
  Specialization clickedSpecialization;
  Element canvasMenu;
  
  SpecializationCanvasMenuStrategy(
      CanvasRenderingContext2D ctx,
      SpecializationController specializationController, 
      TableController tableController,
      CanvasActionsController canvasActionsContorller, 
      Specialization clickedSpecialization){
    this.ctx = ctx;
    this.specializationController = specializationController;
    this.tableController = tableController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.clickedSpecialization = clickedSpecialization;  
    this.canvasMenu = querySelector("#canvas_menu");
  }
  
  void executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(clickOrigin == CanvasInteractionStrategy.RIGHT_CLICK){
      canvasMenu.nodes.clear();
      _createCanvasMenuEntries();
      _handleDeleteModelButton();
      _handleEditModelButton(canvasMousePosition);
      specializationController.toggle(clickedSpecialization);
      canvasActionsContorller.setDefaultCanvasInteractionContext();
    }
  }
  
  _createCanvasMenuEntries(){
    LIElement editModel = new LIElement();
    AnchorElement editModelAnchor = new AnchorElement();
    editModelAnchor.id = "edit_specialization";
    editModel.nodes.add(editModelAnchor);
    
    LIElement deleteModel = new LIElement();
    AnchorElement deleteModelAnchor = new AnchorElement();
    deleteModelAnchor.id = "delete_specialization";
    deleteModel.nodes.add(deleteModelAnchor);
    
    editModelAnchor.text = "Especializar/generalizar outra entidade";
    deleteModelAnchor.text = "Deletar especialização/generalização";
    
    canvasMenu.nodes.add(editModel);
    canvasMenu.nodes.add(deleteModel);
    
  }
  
  void _handleDeleteModelButton(){
    Element deleteModelButton = querySelector('#delete_specialization');
    deleteModelButton.onClick.listen((MouseEvent evt)  {
      specializationController.deleteSpecialization(clickedSpecialization);
    });
 }
  
  void _handleEditModelButton(Point canvasMousePosition){
    Element editModelButton = querySelector("#edit_specialization");
    editModelButton.onClick.listen((MouseEvent evt) {
      canvasActionsContorller.setCanvasInteractionContext(
          new SpecializationNewConnectionStrategy(ctx, tableController, specializationController, canvasActionsContorller, clickedSpecialization, canvasMousePosition)
       );
    });
  }
}