part of coloph;

class TableModalFactory extends ModalFactory{
  
  setLogicalModal(){
    logicalViews = true;
    conceptualViews = false;
  }
  
  setConceptualModal(){
    logicalViews = false;
    conceptualViews = true;
  }
  
  TableModal newTableModal(Table table, TableController tableController, bool physical){
    if(logicalViews)
      return new LogicalTableModal(table, tableController, "#logical_table_modal", physical);
    if(conceptualViews)
      return new ConceptualTableModal(table, tableController, "#conceptual_table_modal");
  }
}