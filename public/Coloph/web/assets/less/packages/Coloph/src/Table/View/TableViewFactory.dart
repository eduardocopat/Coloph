part of coloph;

class TableViewFactory extends ViewFactory{
  List<TableView> tableViews;
  
  TableViewFactory(CanvasRenderingContext2D ctx){
    this.tableViews = []; 
    this.ctx = ctx;
  }
  
  setLogicalViews(){
    logicalViews = true;
    conceptualViews = false;
    recreateViews();
  }
  
  setConceptualViews(){
    logicalViews = false;
    conceptualViews = true;
    recreateViews();
  }
  
  TableView newTableView(Table table, BorderInteractionController borderInteractionController, TableController tableController){
    TableView tableView;
    if(logicalViews)
      tableView =  new LogicalTableView(ctx, table, borderInteractionController, tableController);
    if(conceptualViews)
      tableView = new ConceptualTableView(ctx, table, borderInteractionController, tableController);
    
    tableViews.add(tableView);
    return tableView;
  } 
  
  void recreateViews(){
    if(!tableViews.isEmpty){
      List<TableView> copiedViews = _copyViews();
      BorderInteractionController borderInteractionController = copiedViews[0].borderInteractionController;
      TableController tableController = copiedViews[0].tableController;
      tableViews.clear();
      for(TableView tv in copiedViews){
        newTableView(tv.table, borderInteractionController, tableController);
      }
    }
  }
  
  List<TableView> _copyViews(){
    List<TableView> copiedViews = [];
    for(TableView tv in tableViews){
      copiedViews.add(tv);
    }
    return copiedViews;
  }
  

  

}

