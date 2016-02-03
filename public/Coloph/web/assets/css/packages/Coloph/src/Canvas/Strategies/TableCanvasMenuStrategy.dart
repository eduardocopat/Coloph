part of coloph;

/** This strategy is triggered when a table is right clicked in the canvas **/
class TableCanvasMenuStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  TableController tableController;
  CanvasActionsController canvasActionsContorller;
  Table clickedTable;
  Element canvasMenu;
  
  TableCanvasMenuStrategy(CanvasRenderingContext2D ctx,
                          TableController tableController, 
                          CanvasActionsController canvasActionsContorller, 
                          Table clickedTable){
    this.ctx = ctx;
    this.tableController = tableController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.clickedTable = clickedTable;  
    this.canvasMenu = querySelector("#canvas_menu");
  }
  
  void executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(clickOrigin == CanvasInteractionStrategy.RIGHT_CLICK){
      canvasMenu.nodes.clear();
      _createCanvasMenuEntries();
      _handleDeleteModelButton();
      _handleEditModelButton();
      tableController.toggle(clickedTable);
      canvasActionsContorller.setDefaultCanvasInteractionContext();
    }
  }
  
  _createCanvasMenuEntries(){
    LIElement editModel = new LIElement();
    AnchorElement editModelAnchor = new AnchorElement();
    editModelAnchor.id = "edit_table";
    editModel.nodes.add(editModelAnchor);
    
    LIElement deleteModel = new LIElement();
    AnchorElement deleteModelAnchor = new AnchorElement();
    deleteModelAnchor.id = "delete_table";
    deleteModel.nodes.add(deleteModelAnchor);
    
    editModelAnchor.text = "Editar entidade";
    deleteModelAnchor.text = "Deletar entidade";
    
    canvasMenu.nodes.add(editModel);
    canvasMenu.nodes.add(deleteModel);
    
  }
  
  void _handleDeleteModelButton(){
    Element deleteModelButton = querySelector('#delete_table');
    deleteModelButton.onClick.listen((MouseEvent evt)  {
      tableController.deleteTable(clickedTable);
    });
 }
  
  void _handleEditModelButton(){
    Element editModelButton = querySelector("#edit_table");
    editModelButton.onClick.listen((MouseEvent evt) {
      tableController.editTable(clickedTable);
    });
  }
}