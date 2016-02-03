part of coloph;

class LogicalModalTableFieldBuilder extends ModalBaseFieldBuilder{
  bool physical;
  
  LogicalModalTableFieldBuilder(Element tableBody, bool physical):super(tableBody){
    this.physical = physical;
  }
  
  void setMoreFieldRowsBtnId(){
    moreFieldRowsBtnId = "more_field_rows_logical_table";
  }
  
  buildBaseFieldRow(TableField tableField){
    super.buildBaseFieldRow(tableField);
    //Removes the last TR (which contains the add row button)
    if(tableBody.children.length != 0)
      tableBody.lastChild.remove();
    
    TableRowElement tableFieldRow = new TableRowElement();
    tableFieldRow.id = tableField.id.toString();
    tableBody.nodes.add(tableFieldRow);
    
    StreamSubscription removeButtonStreamSub =_addRemoveButton(tableFieldRow);
    InputElement primaryKeyInput = _addPrimaryKey(tableFieldRow);
    InputElement nameInput = _addFieldName(tableFieldRow);
    InputElement nullsInput = _addNulls(tableFieldRow);
    _addForeignKey(tableFieldRow);
    /*
    InputElement dataTypeInput = _addDataType(tableFieldRow);
    
    if(physical)
      dataTypeInput.style.display = "";
    else  
      dataTypeInput.style.display = "none";
      */
    if(physical)
      InputElement dataTypeInput = _addDataType(tableFieldRow);
    
    _addMoreFieldsRow(tableBody);
    
    primaryKeyInput.onClick.listen((Event evt) {
      if(primaryKeyInput.checked == true){
         nullsInput.checked = false;
      }
    });
    
    disableNullsOnPrimaryKey(primaryKeyInput, nullsInput);
    primaryKeyInput.onChange.listen((Event evt) {
      disableNullsOnPrimaryKey(primaryKeyInput, nullsInput);
    });
    
    if(baseField.foreignKey.value == true){
      removeButtonStreamSub.cancel();
      nameInput.disabled = true;
      primaryKeyInput.disabled = true;
      nullsInput.disabled = true;
    }
  }

  void disableNullsOnPrimaryKey(InputElement primaryKeyInput, InputElement nullsInput) {
    if(primaryKeyInput.checked == true)
       nullsInput.disabled = true;
    else
      nullsInput.disabled = false;
  }
  
  _addExtraCells(TableRowElement moreFieldRowsTr){
    TableRowElement tableHeader = querySelector("#logical_field_table_header_row");
    int numberOfHeaders = tableHeader.children.length - 1;
    for(int i = 0; i< numberOfHeaders; i++){
      moreFieldRowsTr.nodes.add(new TableCellElement());
    }
  }
  
  _removeSubFields(Element linkRemove){}
  _createSubField(BaseField baseField, int subFieldRowIndex){}
}