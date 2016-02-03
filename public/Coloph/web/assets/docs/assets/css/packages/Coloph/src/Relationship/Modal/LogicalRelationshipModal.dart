part of coloph;

class LogicalRelationshipModal extends RelationshipModal{
  InputElement nameInput; 
  InputElement dataTypeInput;
  InputElement nullAllowedInput; 
  InputElement cardinalityInput;
  InputElement parentNameInput;
  InputElement childNameInput;
  DivElement nullAllowedGroup;
  DivElement cardinalityGroup;
  
  LogicalRelationshipModal(Relationship relationship, String modalType, RelationshipController relationshipController, String modalId)
      :super(relationship, modalType, relationshipController, modalId){ 
    _setRelationshipMode();
  }
  
  void _setRelationshipMode(){
    //Changing the relationship type in edition is too complicated, mainly due to some requests synchronization problems
    //So it is disabled
    dataTypeInput.disabled = true; 
    
    switch(relationship.dataType){
      case Relationship.IDENTIFYING_RELATIONSHIP:
        _setIdentifyingMode();
        break;
      case Relationship.NON_IDENTIFYING_RELATIONSHIP:
        _setNonIdentifyingMode();
        break;
      case Relationship.MANY_TO_MANY_RELATIONSHIP:
        _setManyToManyMode();
        break;
      case Relationship.SELF_RELATIONSHIP:
        _setSelfMode();
        break;      
    }
  }
  
  void _setIdentifyingMode(){
    nullAllowedInput.value = Relationship.NOT_ALLOW_NULLS;
    nullAllowedInput.disabled = true;
  }
  
  void _setNonIdentifyingMode(){
    nullAllowedInput.disabled = false;
  }
  
  void _setManyToManyMode(){
    //nullAllowedInput.style.display = "";
    nullAllowedGroup.style.display = "none";
    cardinalityGroup.style.display = "none";
  }
  
  void _setSelfMode(){
    dataTypeInput.disabled = true;
  }

  void loadInputElements() {
    this.nameInput = querySelector("#logical_relationship_name");
    this.dataTypeInput = querySelector("#logical_relationship_data_type");
    this.nullAllowedInput = querySelector("#logical_relationship_null_allowed");
    this.cardinalityInput = querySelector("#logical_relationship_cardinality");
    this.parentNameInput = querySelector("#logical_relationship_parent_name");
    this.childNameInput = querySelector("#logical_relationship_child_name");
    this.nullAllowedGroup = querySelector("#logical_relationship_null_allowed_group");
    this.cardinalityGroup = querySelector("#logical_relationship_cardinality_group");
    
  }
 
  _populateInputFromModel(){
    loadInputElements();
    parentNameInput.value = relationship.parentTable.name;
    childNameInput.value = relationship.childTable.name; 
    nameInput.value = relationship.name;
    dataTypeInput.value = relationship.dataType;
    nullAllowedInput.value = relationship.nullAllowed;
    cardinalityInput.value = relationship.parentCardinality;
  }
  
  _populateModelWithInput(){   
    loadInputElements();
    relationship.name = nameInput.value;
    if(relationship.name.isEmpty){
      print("relationship name is empty");
      relationship.name = relationship.parentTable.name + relationship.childTable.name;
    }
      
    relationship.dataType = dataTypeInput.value;
    relationship.nullAllowed = nullAllowedInput.value;
    relationship.parentCardinality = cardinalityInput.value;
  }
  
  _clearModal(){
    loadInputElements();
    nameInput.value = "";
    dataTypeInput.disabled = true;
    nullAllowedInput.disabled = false;
    nullAllowedInput.value = Relationship.ALLOW_NULLS;
    cardinalityInput.value = Relationship.ZERO_OR_ONE;
    
    nullAllowedGroup.style.display = "";
    cardinalityGroup.style.display = "";
    
    
  }
  
  void setIdentifyingMode(){
    
  }
  
  setModelingType(){
    modelingType = "logical"; 
  }
  
  _addRelationshipFieldRow(RelationshipField relationshipField){
    //Logical model does not have field
  }

  
}