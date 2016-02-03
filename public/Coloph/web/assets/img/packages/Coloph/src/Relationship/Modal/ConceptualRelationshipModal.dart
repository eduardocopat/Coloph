part of coloph;

class ConceptualRelationshipModal extends RelationshipModal{
  Element tableBody;
  Relationship oldRelationship;
  ConceptualRelationshipModal(Relationship relationship, String modalType, RelationshipController relationshipController, String modalId)
      :super(relationship, modalType, relationshipController,modalId){
    oldRelationship = relationship.clone();
    tableBody = querySelector("#relationship_fields_table_body");
  }
  
  void setModelingType(){
    modelingType = "conceptual"; 
  }
  
  _addRelationshipFieldRow(RelationshipField relationshipField){
    Element tableBody = querySelector("#relationship_fields_table_body");
    
    ConceptualModalRelationshipFieldBuilder cmrfb = new ConceptualModalRelationshipFieldBuilder(tableBody);
    cmrfb.buildBaseFieldRow(relationshipField);
  }

  
  _populateInputFromModel(){
    _populateTableNames();
    _linkParentTableToTernaryParentCardinalities();
    _defineTernaryFieldsVisibility();
    _defineSelfRelationshipRolesVisibility();
    //identifying;  
    InputElement relationshipIdentifyting = querySelector("#conceptual_identifying_relationship");
    relationshipIdentifyting.checked = relationship.identifying;
    
    if(relationship.parentTable == relationship.childTable){
      InputElement relationshipSelf = querySelector("#conceptual_auto_relationship");
      relationshipSelf.checked = true;
    }
    
    if(relationship.relationshipFields.length == 0){
      RelationshipField dummyRelationshipField = new BaseField.dummy();
      _addRelationshipFieldRow(dummyRelationshipField);
    }
    else{
      for(RelationshipField relationshipField in relationship.relationshipFields){
        _addRelationshipFieldRow(relationshipField);
      }
    }
    if(relationship.name.isNotEmpty){
      //parent_cardinality_min;
      InputElement relationshipParentCardinality = querySelector("#conceptual_relationship_cardinality_parent");
      relationshipParentCardinality.value = relationship.parentCardinality;
       
      InputElement relationshipTernaryParentCardinality = querySelector("#conceptual_relationship_ternary_cardinality_parent");
      relationshipTernaryParentCardinality.value = relationship.parentCardinality;
      
      if(relationship.ternaryTable != null){
        InputElement relationshipTernaryCardinality = querySelector("#conceptual_relationship_ternary_cardinality_child");
        relationshipTernaryCardinality.value = relationship.ternaryCardinality;
      }
      
      if(relationship.dataType == Relationship.SELF_RELATIONSHIP){
        InputElement relationshipParentRole = querySelector("#conceptual_relationship_parent_role");
        relationshipParentRole.value = relationship.parentRole;
        
        InputElement relationshipChildRole = querySelector("#conceptual_relationship_child_role");
        relationshipChildRole.value = relationship.childRole;
      }
       
      //child_cardinality_min;
      InputElement relationshipChildCardinalityMin = querySelector("#conceptual_relationship_cardinality_child");
      relationshipChildCardinalityMin.value = relationship.childCardinality;
    }
  }
 

    _populateModelWithInput(){
      //name
      InputElement relationshipName = querySelector("#conceptual_relationship_name");
      relationship.name = relationshipName.value;
      
      InputElement relationshipParentCardinality = querySelector("#conceptual_relationship_cardinality_parent");
      relationship.parentCardinality = relationshipParentCardinality.value;
      
      InputElement relationshipChildCardinality = querySelector("#conceptual_relationship_cardinality_child");
      relationship.childCardinality = relationshipChildCardinality.value;

      if(relationship.ternaryTable != null){
        InputElement relationshipTernaryCardinality = querySelector("#conceptual_relationship_ternary_cardinality_child");
        relationship.ternaryCardinality = relationshipTernaryCardinality.value ;
      }
      
      InputElement relationshipParentRole = querySelector("#conceptual_relationship_parent_role");
      relationship.parentRole = relationshipParentRole.value;
        
      InputElement relationshipChildRole = querySelector("#conceptual_relationship_child_role");
      relationship.childRole = relationshipChildRole.value;
      
      //identifying;  
      InputElement relationshipIdentifyting = querySelector("#conceptual_identifying_relationship");
      relationship.identifying = relationshipIdentifyting.checked;
      
      relationship.relationshipFields.clear();
      RelationshipField relationshipField;
      //Populate table fields
      TableElement fieldTable = querySelector("#relationship_field_table");
      for(TableRowElement fieldRow in fieldTable.rows){
        //Skips header
        // if ((fieldRow.cells[0] as TableCellElement).tagName == "TH") - Commented out because not sure if it will work 
        if (fieldRow.cells[0].tagName == "TH")
          continue;
        
        //Skip the last line, which contains the (+) button
        if(fieldRow.id == "moreFieldRows")
          continue;
        
        if(fieldRow.className == "sub_field_row"){
          RelationshipField subRelationshipField = _readAsRelationshipSubField(fieldRow);
          if(subRelationshipField != null)
            relationshipField.baseSubFields.add(subRelationshipField);
        
        } else if (fieldRow.className == "more_sub_field_rows_button") { 
          continue;
        } else {
          relationshipField = _readAsRelationshipField(fieldRow);
          if(relationshipField != null)
            relationship.relationshipFields.add(relationshipField);
        }
      }
      
      _mapOldPositions(relationship, oldRelationship);
  }
    
    void _defineTernaryFieldsVisibility(){
      DivElement ternaryDiv = querySelector("#ternaryRelationsihp");
      if(relationship.ternaryTable == null)
        ternaryDiv.style.display = "none";        
      else
        ternaryDiv.style.display = "";      
    }
    
    void _defineSelfRelationshipRolesVisibility(){
      DivElement rolesDiv = querySelector("#self_relationship_roles_div");
      if(relationship.dataType == Relationship.SELF_RELATIONSHIP)
        rolesDiv.style.display = "";          
      else
        rolesDiv.style.display = "none";
    }
    
    void _linkParentTableToTernaryParentCardinalities(){
      //parent_cardinality_min;
      InputElement relationshipParentCardinality = querySelector("#conceptual_relationship_cardinality_parent");
      InputElement relationshipTernaryParentCardinality = querySelector("#conceptual_relationship_ternary_cardinality_parent");
      
      relationshipParentCardinality.onChange.listen((Event evt) {
        relationshipTernaryParentCardinality.value =  relationshipParentCardinality.value;
      });
    }
    
    void _populateTableNames(){
      InputElement relationshipNameInput = querySelector("#conceptual_relationship_name");
      relationshipNameInput.value = relationship.name;
      
      InputElement inputParentTableName = querySelector("#conceptual_relationship_parent_name");
      InputElement inputChildTableName = querySelector("#conceptual_relationship_child_name");
      
      InputElement inputParentTernaryTableName = querySelector("#conceptual_relationship_ternary_parent_name");
      InputElement inputTernaryTableName = querySelector("#conceptual_relationship_ternary_name");
      
      //inputParentTableName.placeholder = parentTableName;
      inputParentTableName.value = relationship.parentTable.name;
      inputChildTableName.value = relationship.childTable.name;
      inputParentTernaryTableName.value = relationship.parentTable.name;
      
      if(relationship.ternaryTable != null)
        inputTernaryTableName.value = relationship.ternaryTable.name;
    }
    
    RelationshipField _readAsRelationshipField(TableRowElement fieldRow){
    //Get the value from input of table cells
    List<TableCellElement> fieldRowCells = fieldRow.cells;
    
    int relationshipFieldId;
    if(fieldRow.id != "null")
      relationshipFieldId = int.parse(fieldRow.id);
    
    Element primaryKeyCell = fieldRowCells[2];
    InputElement primaryKeyInput = primaryKeyCell.children[0];
    bool primaryKey = primaryKeyInput.checked; 
    
    Element nameCell = fieldRowCells[3];
    InputElement nameInput = nameCell.children[1];
    String name = nameInput.value;
    if(name.isEmpty){
      return null;
    }
    
    Element compositeCell = fieldRowCells[4];
    InputElement compositeInput = compositeCell.children[0];
    bool composite = compositeInput.checked; 

    Element multivaluedCell = fieldRowCells[5];
    InputElement multivaluedInput = multivaluedCell.children[0];
    bool multivalued = multivaluedInput.checked;
    
    Element nullsCell = fieldRowCells[6];
    InputElement nullsInput = nullsCell.children[0];
    bool nulls = nullsInput.checked;
    
    Element derivedCell = fieldRowCells[7];
    InputElement derivedInput = derivedCell.children[0];
    bool derived = derivedInput.checked;
    
    return new RelationshipField(relationshipFieldId, name, primaryKey, new ForeignKey(false,-1), nulls, composite, multivalued, derived, null);
  }
  
  RelationshipField _readAsRelationshipSubField(TableRowElement fieldRow){
    //Get the value from input of table cells
    List<TableCellElement> fieldRowCells = fieldRow.cells;
    
    int relationshipSubFieldId;
    if(fieldRow.id != "null")
      relationshipSubFieldId = int.parse(fieldRow.id);
    
    Element nameCell = fieldRowCells[2];
    InputElement nameInput = nameCell.children[1];
    String name = nameInput.value;
    if(name.isEmpty){
      return null;
    }
    
    Element multivaluedCell = fieldRowCells[4];
    InputElement multivaluedInput = multivaluedCell.children[0];
    bool multivalued = multivaluedInput.checked;
    
    Element nullsCell = fieldRowCells[5];
    InputElement nullsInput = nullsCell.children[0];
    bool nulls = nullsInput.checked;
    
    Element derivedCell = fieldRowCells[6];
    InputElement derivedInput = derivedCell.children[0];
    bool derived = derivedInput.checked;
    
    return new RelationshipField(relationshipSubFieldId, name, false, new ForeignKey(false,-1), nulls, null, multivalued, derived, null);
  }
  
  
 _clearModal(){
    _clearHelpSpans();
    _clearControlGroupDivs();
    InputElement name = querySelector("#conceptual_relationship_name");
    name.value = "";
    InputElement relationshipSelf = querySelector("#conceptual_auto_relationship");
    relationshipSelf.checked = false;
    InputElement relationshipIdentifyting = querySelector("#conceptual_identifying_relationship");
    relationshipIdentifyting.checked = false;
    
    //InputElement nullAllowed = querySelector("#relationship_null_allowed");
    //InputElement cardinality = querySelector("#relationship_cardinality");
    querySelector("#relationship_fields_table_body").nodes.clear();
  }
}