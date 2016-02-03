part of coloph;

class ConceptualModalTableFieldBuilder extends ModalBaseFieldBuilder{
  
  ConceptualModalTableFieldBuilder(Element tableBody):super(tableBody);
  
  void setMoreFieldRowsBtnId(){
    moreFieldRowsBtnId = "more_field_rows_conceptual_table";
  }
  
  buildBaseFieldRow(TableField tableField){
    super.buildBaseFieldRow(tableField);
    //Removes the last TR (which contains the add row button)
    if(super.tableBody.children.length != 0)
      super.tableBody.lastChild.remove();
    
    TableRowElement tableFieldRow = new TableRowElement();
    tableFieldRow.id = tableField.id.toString();
    
    Element tableBody = querySelector("#conceptual_field_table_body");
    tableBody.nodes.add(tableFieldRow);

    StreamSubscription removeButtonStreamSub = _addRemoveButton(tableFieldRow);
    InputElement primaryKeyInput = _addPrimaryKey(tableFieldRow);
    InputElement nameInput = _addFieldName(tableFieldRow);
    _addForeignKey(tableFieldRow);
    InputElement compositeInput = _addComposite(tableFieldRow);
    InputElement multiInput = _addMultivalued(tableFieldRow);
    InputElement nullsInput = _addNulls(tableFieldRow);
    InputElement derivedInput =  _addDerived(tableFieldRow); 
 
    int rowIndex = tableBody.nodes.indexOf(tableFieldRow, 0);
    if(tableField.composite){
      for(TableField subTableField in tableField.baseSubFields ){
        _createSubField(subTableField,rowIndex+1);
        rowIndex++; //Incremeting in case there are more sub fields
      }
    }
    
    _addMoreFieldsRow(tableBody);
    
    primaryKeyInput.onClick.listen((Event evt) {
      if(primaryKeyInput.checked == true){
         nullsInput.checked = false;
      }
    });
    

    Element compositeInputCheckbox = querySelector("#${compositeInput.id}");
    compositeInput.onClick.listen((Event evt) {
      if(compositeInput.checked == true){
        BaseField dummyBaseField = new BaseField.dummy();
        int rowIndex = tableBody.nodes.indexOf(tableFieldRow, 0);
        _addMoreSubFieldsRow(rowIndex+1 );
      }
     });
    
    if(baseField.foreignKey.value == true){
      primaryKeyInput.disabled = true;
      removeButtonStreamSub.cancel();
      nameInput.disabled = true;
      compositeInput.disabled = true;
      multiInput.disabled = true;
      nullsInput.disabled = true;
      derivedInput.disabled = true; 
    }
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
        
        
      TableRowElement tableSubFieldRow = new TableRowElement();
      tableSubFieldRow.id = baseField.id.toString();
      
      tableSubFieldRow.classes = ["sub_field_row"];
      tableBody.nodes.insert(subFieldRowIndex, tableSubFieldRow);
      
      //Adds an empty cell element for identation
      tableSubFieldRow.nodes.add(new TableCellElement());
      StreamSubscription removeButtonStreamSub = _addRemoveButton(tableSubFieldRow);
      InputElement nameInput = _addFieldName(tableSubFieldRow);
      tableSubFieldRow.nodes.add(new TableCellElement()); // foreign key empty cell
      tableSubFieldRow.nodes.add(new TableCellElement()); // composite key empty cell
      InputElement multiInput = _addMultivalued(tableSubFieldRow);
      InputElement nullsInput = _addNulls(tableSubFieldRow);
      InputElement derivedInput = _addDerived(tableSubFieldRow);
      
      StreamSubscription moreFieldRowsButtonStreamsub = _addMoreSubFieldsRow(subFieldRowIndex+1);
      
      if(baseField.foreignKey.value == true){
        //Disable fields
        removeButtonStreamSub.cancel();     
        nameInput.disabled = true;
        multiInput.disabled = true;
        nullsInput.disabled = true;
        derivedInput.disabled = true;
        moreFieldRowsButtonStreamsub.cancel();
      }
    }
    
    void _removeSubFields(Element linkRemove){
      Element fieldLine = linkRemove.parent.parent;
      
      int mainFieldIndex = tableBody.nodes.indexOf(linkRemove.parent.parent);
      mainFieldIndex++; //get next row
      //if it is a sub field line, then remove it.
      //sub fields have a class named sub_field_row
      TableRowElement tableSubFieldRow;
      tableSubFieldRow = tableBody.nodes.elementAt(mainFieldIndex);
      while(tableSubFieldRow.className == "sub_field_row" ||
            tableSubFieldRow.className == "more_sub_field_rows_button"){
        tableSubFieldRow.remove();
        tableSubFieldRow = tableBody.nodes.elementAt(mainFieldIndex);
      }
    }
}