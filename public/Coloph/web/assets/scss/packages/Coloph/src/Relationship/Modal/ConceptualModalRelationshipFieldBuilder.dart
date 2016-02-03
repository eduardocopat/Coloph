part of coloph;

class ConceptualModalRelationshipFieldBuilder extends ModalBaseFieldBuilder{
  
  ConceptualModalRelationshipFieldBuilder(Element tableBody):super(tableBody);
  
  void setMoreFieldRowsBtnId(){
    moreFieldRowsBtnId = "more_field_rows_conceptual_relationship";
  }
  
  buildBaseFieldRow(RelationshipField relationshipField){
    super.buildBaseFieldRow(relationshipField);
    //Removes the last TR (which contains the add row button)
    if(super.tableBody.children.length != 0)
      super.tableBody.lastChild.remove();
    
    TableRowElement relationshipFieldRow = new TableRowElement();
    relationshipFieldRow.id = relationshipField.id.toString();
    
    Element tableBody = querySelector("#relationship_fields_table_body");
    tableBody.nodes.add(relationshipFieldRow);

    _addRemoveButton(relationshipFieldRow);
    relationshipFieldRow.nodes.add(new TableCellElement());
    _addPrimaryKey(relationshipFieldRow);
    _addFieldName(relationshipFieldRow);
    InputElement compositeInput = _addComposite(relationshipFieldRow);
    _addMultivalued(relationshipFieldRow);
    _addNulls(relationshipFieldRow);
    _addDerived(relationshipFieldRow); 
 
    int rowIndex = tableBody.nodes.indexOf(relationshipFieldRow, 0);
  
    if(relationshipField.composite){
      for(BaseField subRelationshipField in relationshipField.baseSubFields ){
        _createSubField(subRelationshipField,rowIndex+1);
        rowIndex++; //Incremeting in case there are more sub fields
      }
    }
    
    _addMoreFieldsRow(tableBody);
    
    
    Element compositeInputCheckbox = querySelector("#${compositeInput.id}");
    compositeInput.onClick.listen((Event evt) {
      if(compositeInput.checked == true){
        BaseField dummyBaseField = new BaseField.dummy();
        int rowIndex = tableBody.nodes.indexOf(relationshipFieldRow, 0);
        _addMoreSubFieldsRow(rowIndex+1 );
      }
     });
  }
  
    _addExtraCells(moreFieldRowsTr){
      const int NUMBER_OF_HEADERS = 7;
      for(int i = 0; i< NUMBER_OF_HEADERS; i++){
        moreFieldRowsTr.nodes.add(new TableCellElement());
      }
    }
      
    void _createSubField(BaseField baseField, int subFieldRowIndex){
      this.baseField = baseField; // <---
      
      //Avoids the case when we're adding the second row and there isn't the "add more fields button"
      int tableBodyNodesLength = tableBody.nodes.length; 
      if(tableBodyNodesLength != subFieldRowIndex)
        tableBody.nodes.removeAt(subFieldRowIndex);
        
      TableRowElement relationshipSubFieldRow = new TableRowElement();
      relationshipSubFieldRow.id = baseField.id.toString();
      
      relationshipSubFieldRow.classes = ["sub_field_row"];
      tableBody.nodes.insert(subFieldRowIndex, relationshipSubFieldRow);
      
      //Adds an empty cell element for identation
      relationshipSubFieldRow.nodes.add(new TableCellElement());
      _addRemoveButton(relationshipSubFieldRow);
      _addFieldName(relationshipSubFieldRow);
      relationshipSubFieldRow.nodes.add(new TableCellElement()); // composite key empty cell
      _addMultivalued(relationshipSubFieldRow);
      _addNulls(relationshipSubFieldRow);
      _addDerived(relationshipSubFieldRow);
      
      _addMoreSubFieldsRow(subFieldRowIndex+1);
    }
    
    void _removeSubFields(Element linkRemove){
      Element fieldLine = linkRemove.parent.parent;
      
      int mainFieldIndex = tableBody.nodes.indexOf(linkRemove.parent.parent);
      mainFieldIndex++; //get next row
      //if it is a sub field line, then remove it.
      //sub fields have a class named sub_field_row
      TableRowElement RelationshipSubFieldRow;
      RelationshipSubFieldRow = tableBody.nodes.elementAt(mainFieldIndex);
      while(RelationshipSubFieldRow.className == "sub_field_row" ||
            RelationshipSubFieldRow.className == "more_sub_field_rows_button"){
        RelationshipSubFieldRow.remove();
        RelationshipSubFieldRow = tableBody.nodes.elementAt(mainFieldIndex);
      }
    }
}