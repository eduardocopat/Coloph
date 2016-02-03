part of coloph;

class ConceptualTableModal extends TableModal{
  Table oldTable;
  ConceptualTableModal(Table table, TableController tableController, String modalId):super(table,tableController, modalId, false){
    tableElementIdName = "#conceptual_table_name";
    oldTable = table.clone(); 
  }
  
  _populateInputFromModel(){
    InputElement tableName = querySelector("#conceptual_table_name");
    tableName.value = table.name;
    //If the table is being created, it has no table fields
    if(table.tableFields.length == 0){
      TableField dummyTableField = new BaseField.dummy();
      _addTableFieldRow(dummyTableField);
    }
    else{
      for(TableField tableField in table.tableFields){
        _addTableFieldRow(tableField);
      }
      
    }
    
  }
 
  _populateModelWithInput(){
    InputElement tableName = querySelector("#conceptual_table_name");
    table.name = tableName.value;
    tableAndTableFieldsValidationCheck.add(table);
    
    //Clear everything except foreignKeys
    table.tableFields.clear();
    for(TableField tableField in table.tableFields){
      if(tableField.foreignKey.value == false)
        table.tableFields.remove(tableField);
    }
    
    TableField tableField;
    //Populate table fields
    TableElement fieldTable = querySelector("#conceptual_field_table");
    for(TableRowElement fieldRow in fieldTable.rows){
      //Skips header
      // if ((fieldRow.cells[0] as TableCellElement).tagName == "TH") - Commented out because not sure if it will work 
      if (fieldRow.cells[0].tagName == "TH")
        continue;
      
      //Skip the last line, which contains the (+) button
      if(fieldRow.id == "moreFieldRows")
        continue;
       
      if(fieldRow.className == "sub_field_row"){
        TableField subTableField =  _readAsTableSubField(fieldRow);
        if(subTableField != null)
          tableField.baseSubFields.add(subTableField);
        
        //Commented out because validations occur in table field level
        //tableRowTableFieldRelation[subTableField] = fieldRow;
        //tableAndTableFieldsValidationCheck.add(subTableField);
        
      } else if (fieldRow.className == "more_sub_field_rows_button") { 
        continue;
      } else {
        tableField = _readAsTableField(fieldRow);
        if(tableField != null){
          table.tableFields.add(tableField);
          tableRowTableFieldRelation[tableField] = fieldRow;
          tableAndTableFieldsValidationCheck.add(tableField);
        }
      }
    }
    
    _mapOldPositions(table, oldTable);
  }
  
 TableField _readAsTableField(TableRowElement fieldRow){
    //Get the value from input of table cells
    List<TableCellElement> fieldRowCells = fieldRow.cells;
    int tableFieldId;
    if(fieldRow.id != "null")
       tableFieldId = int.parse(fieldRow.id);
      
    Element primaryKeyCell = fieldRowCells[1];
    InputElement primaryKeyInput = primaryKeyCell.children[0];
    bool primaryKey  = primaryKeyInput.checked;
    
    Element nameCell = fieldRowCells[2];
    InputElement nameInput = nameCell.children[1];
    String name = nameInput.value;
    if(name.isEmpty){
      return null;
    }
    
    Element foreignKeyCell = fieldRowCells[3];
    InputElement foreignKeyInput = foreignKeyCell.children[0];
    ForeignKey foreignKey;
    if(foreignKeyInput.checked)
      foreignKey = new ForeignKey(true,-1);
    else
      foreignKey = new ForeignKey(false,-1);
    
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
    
    return new TableField(tableFieldId, name, primaryKey, foreignKey, "", nulls, composite, multivalued, derived, null);
  }
  
  TableField  _readAsTableSubField(TableRowElement fieldRow){
    //Get the value from input of table cells
    List<TableCellElement> fieldRowCells = fieldRow.cells;
    
    int subTableFieldId;
    if(fieldRow.id != "null")
      subTableFieldId = int.parse(fieldRow.id);
    
    Element nameCell = fieldRowCells[2];
    InputElement nameInput = nameCell.children[1];
    String name = nameInput.value;
    if(name.isEmpty){
      return null;
    }
    
    ForeignKey foreignKey = new ForeignKey(false,-1);
    
    Element multivaluedCell = fieldRowCells[5];
    InputElement multivaluedInput = multivaluedCell.children[0];
    bool multivalued = multivaluedInput.checked;
    
    Element nullsCell = fieldRowCells[6];
    InputElement nullsInput = nullsCell.children[0];
    bool nulls = nullsInput.checked;
    
    Element derivedCell = fieldRowCells[7];
    InputElement derivedInput = derivedCell.children[0];
    bool derived = derivedInput.checked;
    
    return new TableField(subTableFieldId, name, false, foreignKey, "", nulls, false, multivalued, derived, null);
  }
  
  
  void _addTableFieldRow(TableField tableField){
    Element tableBody = querySelector("#conceptual_field_table_body");
    
    ConceptualModalTableFieldBuilder cmtfb = new ConceptualModalTableFieldBuilder(tableBody);
    cmtfb.buildBaseFieldRow(tableField);
    
  }
  
  
  _clearModal(){
    InputElement tableName = querySelector("#table_name");
    tableName.value = "";
    
    //Clear the table fields
    Element tableBody = querySelector("#conceptual_field_table_body");
    tableBody.nodes.clear();
    
    _clearHelpSpans();
    _clearControlGroupDivs();
  }
}