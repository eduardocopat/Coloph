part of coloph;

class LogicalTableModal extends TableModal{
  Table oldTable;
  
  LogicalTableModal(Table table, TableController tableController, String modalId, bool physical):super(table,tableController, modalId, physical){
    tableElementIdName = "#table_name";
    oldTable = table.clone();
    _setTableFieldTypeHeader();
  }
  
  void _setTableFieldTypeHeader(){
    Element tableFieldTypeHeader = querySelector("#logical_table_data_type_header");
    if(physical)
      tableFieldTypeHeader.style.display = "";
    else
      tableFieldTypeHeader.style.display = "none";      
  }
  
  _populateInputFromModel(){
    InputElement tableName = querySelector("#conceptual_table_name");
    tableName.value = table.name;
    //If the table is being created, it has no table fields
    if(table.tableFields.length == 0){
      TableField dummyTableField = new TableField(null, "", true, new ForeignKey(false,-1), "", false, false, false, false, null);
      _addTableFieldRow(dummyTableField);
    }
    else{
      InputElement tableName = querySelector("#table_name");
      tableName.value = table.name;
      
      for(TableField tableField in table.tableFields){
        _addTableFieldRow(tableField);
      }
    }
  }
 
  _populateModelWithInput(){
    InputElement tableName = querySelector("#table_name"); 
    table.name = tableName.value;
    tableAndTableFieldsValidationCheck.add(table);
    
    //Clear everything except foreignKeys
    table.tableFields.clear();
    for(TableField tableField in table.tableFields){
      if(tableField.foreignKey.value == false)
        table.tableFields.remove(tableField);
    }
    
    //Populate table fields
    TableElement fieldTable = querySelector("#logical_field_table");
    for(TableRowElement fieldRow in fieldTable.rows){
      //Skips header
      // if ((fieldRow.cells[0] as TableCellElement).tagName == "TH") - Commented out because not sure if it will work 
      if (fieldRow.cells[0].tagName == "TH")
        continue;
      
      //Skip the last line, which contains the (+) button
      if(fieldRow.id == "moreFieldRows")
        continue;
      
      int tableFieldId;
      if(fieldRow.id != "null")
        tableFieldId = int.parse(fieldRow.id);

      //Get the value from input of table cells
      List<TableCellElement> fieldRowCells = fieldRow.cells;
      
      Element primaryKeyCell = fieldRowCells[1];
      InputElement primaryKeyInput = primaryKeyCell.children[0];
      bool primaryKey  = primaryKeyInput.checked;
      
      Element nameCell = fieldRowCells[2];
      InputElement nameInput = nameCell.children[1];
      String name = nameInput.value;
      
      Element nullsCell = fieldRowCells[3];
      InputElement nullsInput = nullsCell.children[0];
      bool nulls = nullsInput.checked;
      
      Element foreignKeyCell = fieldRowCells[4];
      InputElement foreignKeyInput = foreignKeyCell.children[0];
      ForeignKey foreignKey = new ForeignKey(false,-1);

      String dataType;
      if(physical){      
        Element dataTypeCell = fieldRowCells[5];
        InputElement dataTypeInput = dataTypeCell.children[1];
        dataType = dataTypeInput.value;
      }
      else
        dataType = "";

      TableField tableField = new TableField(tableFieldId, name, primaryKey, foreignKey, dataType, nulls, false, false, false, null);
      table.tableFields.add(tableField);
      
      tableRowTableFieldRelation[tableField] = fieldRow;
      
      tableAndTableFieldsValidationCheck.add(tableField);
      
      _mapOldPositions(table, oldTable);
    }
  }
  
  void _addTableFieldRow(TableField tableField){
    Element tableBody = querySelector("#logical_field_table_body");
    
    LogicalModalTableFieldBuilder lmtfb = new LogicalModalTableFieldBuilder(tableBody, physical);
    lmtfb.buildBaseFieldRow(tableField);
  }
  
  _clearModal(){
    InputElement tableName = querySelector("#table_name");
    tableName.value = "";
    
    //Clear the table fields
    Element tableBody = querySelector("#logical_field_table_body");
    tableBody.nodes.clear();
    
    _clearHelpSpans();
    _clearControlGroupDivs();
  }
  
 
}