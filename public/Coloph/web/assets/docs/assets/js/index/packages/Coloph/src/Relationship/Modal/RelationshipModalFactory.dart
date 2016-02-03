part of coloph;

class RelationshipModalFactory extends ModalFactory{
  
  setLogicalModal(){
    logicalViews = true;
    conceptualViews = false;
  }
  
  setConceptualModal(){
    logicalViews = false;
    conceptualViews = true;
  }
  
  RelationshipModal newTableModal(Relationship relationship, String modalType, RelationshipController relationshipController){
    if(logicalViews)
      return new LogicalRelationshipModal(relationship, modalType, relationshipController, "#logical_relationship_modal");
    if(conceptualViews)
      return new ConceptualRelationshipModal(relationship, modalType, relationshipController, "#conceptual_relationship_modal");
  }
}