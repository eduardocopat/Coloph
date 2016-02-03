part of coloph;

abstract class TableModal extends BaseModal{
  Table table;
  TableController tableController;
  String tableElementIdName;
  String oldTableName;
  
  //Maps the relation between the table field and the its row,
  //will be used for further validation.
  Map tableRowTableFieldRelation;
  
  //Maps all the table and table field lists
  //It is used to check if everything was validated.
  List tableAndTableFieldsValidationCheck;
  
  //Maps all error the controller has found
  List<Map> errorMaps;
  
  bool _submited;
  bool _canceled;
  bool physical;
  
  TableModal(Table table, TableController tableController, String modalId,bool physical){
    this.table = table;
    this.tableController = tableController;
    this._modalId = modalId;
    this.physical = physical;
    this._submited = false;
    this._canceled = false;
    
    
    oldTableName = table.name;
    
    tableRowTableFieldRelation = new Map();
    tableAndTableFieldsValidationCheck = new List();
    errorMaps = new List();
    
    _defineModalType();
    _clearModal();
    _populateInputFromModel();
    _handleSubmit();  
    showModal();
  }
  
  _defineModalType(){
    //If there is no table Id assigned, then we're creating a new table.
    if(table.name == null)
      type = BaseModal.CREATE;
    else
      type = BaseModal.EDIT;
  }
  
  _handleSubmit(){
    _submitListener = querySelector("${_modalId}_submit").onClick.listen((Event evt) {
      waitForValidationInstance("${_modalId}_submit", true);
      tableRowTableFieldRelation.clear();
      tableAndTableFieldsValidationCheck.clear();
      errorMaps.clear();
      _clearHelpSpans();
      _clearControlGroupDivs();
      _populateModelWithInput();
      tableController.validate(table, this);
    });
  }
  
  _populateInputFromModel();
 
  _populateModelWithInput();
  
  receiveErrorsFromTableValidation(Table table, Map errors){
    waitForValidationInstance("${_modalId}_submit", false);
    /*If no errors came from the table validation, try to submit it
     * and remove it from the validation list check
     */
    if(errors.length == 0){
      tableAndTableFieldsValidationCheck.remove(table);
      _submitIfNoError();
    }
    
    if(!ableToValidate(table))
    {
     return;
    }
    
    errorMaps.add(errors);
    tableAndTableFieldsValidationCheck.remove(table);
    _displayTableErrors(errors);
  }
  
  _displayTableErrors(Map errors)
  {
    for(String key in errors.keys)
    {
      List messagesOfKey = errors[key];
      String fullMessage = messagesOfKey[0];
      for(int i = 1; i < messagesOfKey.length; i++)
      {
        fullMessage = "$fullMessage, ${messagesOfKey[i]}";
      }
      
      switch(key)
      {
        case "name":
          Element tableName = querySelector(tableElementIdName); 

          SpanElement helpSpan = new SpanElement();
          helpSpan.classes = ["help-inline"];
          helpSpan.text = fullMessage;
          tableName.parent.nodes.add(helpSpan);
          
          tableName.parent.parent.classes = ["control-group", "error"];
        break;
      }
    }
  }
  
  /* Table fields are validated individually, I receive the errors from
   * the table Controller, the errors will be displayed in the span-inline 
   * in the respective table Cell
   */
  receiveErrorsFromTableFieldValidation(TableField tableField, Map errors){
    /*If no errors came from the table field validation, try to submit it
     * and remove it from the validation list check */
    if(errors.length == 0)
    {
      tableAndTableFieldsValidationCheck.remove(tableField);
      _submitIfNoError();
    }
   
    if(!ableToValidate(tableField)){
      return;
    }
    else{
      errorMaps.add(errors);
      tableAndTableFieldsValidationCheck.remove(tableField);
      _displayTableFieldErrors(tableField, errors);
    }
  }
  
  _displayTableFieldErrors(TableField tableField, Map errors){
    TableRowElement tableFieldRow = tableRowTableFieldRelation[tableField];
    
    for(String key in errors.keys)
    {
      List messagesOfKey = errors[key];
      String fullMessage = messagesOfKey[0];
      for(int i = 1; i < messagesOfKey.length; i++)
      {
        fullMessage = "$fullMessage, ${messagesOfKey[i]}";
      }
      
      switch(key)
      {
        case "name":
          Element tableFieldCell = tableFieldRow.children[2]; 

          SpanElement helpSpan = new SpanElement();
          helpSpan.classes = ["help-inline"];
          helpSpan.text = fullMessage;
          tableFieldCell.nodes.add(helpSpan);
          
          tableFieldCell.classes = ["control-group", "error"];
        break;
      }
    }
  }
  
  bool ableToValidate(Object tableFieldOrTable)
  {
    for(Object listObj in tableAndTableFieldsValidationCheck )
    {
      if(listObj == tableFieldOrTable)
        return true;
    }
    
    if(tableAndTableFieldsValidationCheck.length == 0)
      return false;
    
    return false;
  }
  
  _submitIfNoError(){
    if(_submited)
      return;
   
    //I removed table field validation....
    
   //If there are still things to validate, it can't submit
   //if(tableAndTableFieldsValidationCheck.length != 0)
   //  return;
    
    if(_checkIfErrorsFound() == false){
      hideModal();
      _submited = true;
      cancelSubmitListener();
      if(type == BaseModal.CREATE)
        tableController.createTableRequest(table, true);
      else
        tableController.updateTable(table, oldTableName);
      return;
    }
  }
  
  _checkIfErrorsFound(){
    if(errorMaps.length == 0)
      return false;
    else
      return true;
  }
  
  cancelSubmitListener(){
    if(_canceled == false){
        _submitListener.cancel();
        _canceled = true;
    }
  }
  
  _addTableFieldRow(TableField tableField);
  
  _clearModal();
  
  _clearHelpSpans(){
    List<Element> helpSpans = querySelectorAll(".help-inline");
    for(Element helpSpan in helpSpans)
    {
      helpSpan.remove();
    }
  }
  
  _clearControlGroupDivs(){  
    List<Element> controlGroupDivs = querySelectorAll(".control-group");
      for(Element controlGroupDiv in controlGroupDivs){
        controlGroupDiv.classes = ["control-group"];
      }
  }
  

  
}

