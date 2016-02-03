part of coloph;

abstract class ModalBaseFieldBuilder{
  Element tableBody;
  BaseField baseField;
  Math.Random rng;
  String moreFieldRowsBtnId;

  
  ModalBaseFieldBuilder(Element tableBody){ 
    this.tableBody = tableBody;
    this.rng = new Math.Random();
    setMoreFieldRowsBtnId();
  }
  
  void setMoreFieldRowsBtnId();
  
  buildBaseFieldRow(BaseField baseField){
    this.baseField = baseField; 
  }
  
  StreamSubscription _addRemoveButton(TableRowElement baseFieldRow){
    TableCellElement removeButtonTd = new TableCellElement();
    baseFieldRow.nodes.add(removeButtonTd);

    LinkElement linkRemove   = new LinkElement();
    linkRemove.classes = ["btn", "btn-small"];
    removeButtonTd.nodes.add(linkRemove);

    Element minusIcon = new Element.tag("i");
    minusIcon.classes= ["icon-minus-sign"];
    linkRemove.nodes.add(minusIcon);

    //If the minus  button is clicked,remove the table row
    StreamSubscription streamSub =  linkRemove.onClick.listen((Event evt) {
      if(linkRemove.parent.parent.className != "sub_field_row")
        _removeSubFields(linkRemove);
      linkRemove.parent.parent.remove();
    });
    return streamSub;    
  }
  
  void _removeSubFields(Element linkRemove);
  
  InputElement _addPrimaryKey(TableRowElement baseFieldRow){
    TableCellElement checkboxTd = new TableCellElement();
    baseFieldRow.nodes.add(checkboxTd);

    InputElement primaryKeyInput = new Element.tag("input");
    primaryKeyInput.type = "checkbox";

    if(baseField.primaryKey == true)
      primaryKeyInput.checked = true;
    
    checkboxTd.nodes.add(primaryKeyInput);
    return primaryKeyInput;
  }
  
  InputElement _addFieldName(TableRowElement baseFieldRow){
    TableCellElement fieldNameTd = new TableCellElement();
    baseFieldRow.nodes.add(fieldNameTd);
       
    DivElement controls = new DivElement();
    controls.classes = ["controls"];
    fieldNameTd.nodes.add(controls);
  
    InputElement fieldNameInput =  new Element.tag("input");
    
    fieldNameInput.type = "text";
    fieldNameInput.classes = ["input"];
    fieldNameInput.placeholder = "Nome do campo";
    if(baseField.name != "")
      fieldNameInput.value = baseField.name ;
    
    fieldNameTd.nodes.add(fieldNameInput);
    return fieldNameInput;
  }
    
  InputElement _addForeignKey(TableRowElement baseFieldRow){
    TableCellElement foreignKeyTd = new TableCellElement();
    baseFieldRow.nodes.add(foreignKeyTd);

    InputElement foreignKeyInput = new Element.tag("input");
    foreignKeyInput.type = "checkbox";
    foreignKeyInput.disabled = true;
    if(baseField.foreignKey.value)
      foreignKeyInput.checked = baseField.foreignKey.value;
    
    foreignKeyTd.nodes.add(foreignKeyInput); 
    return foreignKeyInput;
  }
  
  InputElement _addNulls(TableRowElement baseFieldRow){
    TableCellElement nullsTd = new TableCellElement();
    baseFieldRow.nodes.add(nullsTd);

    InputElement nullsInput = new Element.tag("input");
    nullsInput.type = "checkbox";
    if(baseField.nulls == true)
      nullsInput.checked = baseField.nulls;
    
    nullsTd.nodes.add(nullsInput);  
    return nullsInput;
  }
  
  InputElement _addComposite(TableRowElement baseFieldRow){
    TableCellElement compositeTd = new TableCellElement();
    baseFieldRow.nodes.add(compositeTd);

    InputElement compositeInput = new Element.tag("input");
    compositeInput.id = "composite_${rng.nextInt(999999)}";
    compositeInput.type = "checkbox";
    if(baseField.composite == true)
      compositeInput.checked = baseField.composite;
    
    compositeTd.nodes.add(compositeInput);  
    return compositeInput;
  }
  
  InputElement _addMultivalued(TableRowElement baseFieldRow){
    TableCellElement multivaluedTd = new TableCellElement();
    baseFieldRow.nodes.add(multivaluedTd);

    InputElement multivaluedInput = new Element.tag("input");
    
    multivaluedInput.type = "checkbox";
    if(baseField.multivalued == true)
      multivaluedInput.checked = baseField.multivalued;
    
    multivaluedTd.nodes.add(multivaluedInput);  
    return multivaluedInput;
  }
  
  InputElement _addDerived(TableRowElement baseFieldRow){
    TableCellElement derivedTd = new TableCellElement();
    baseFieldRow.nodes.add(derivedTd);

    InputElement derivedInput = new Element.tag("input");
    derivedInput.type = "checkbox";
    if(baseField.derived == true)
      derivedInput.checked = baseField.derived;
    
    derivedTd.nodes.add(derivedInput);  
    return derivedInput;
  }
    
  void _addMoreFieldsRow(Element tableBody){
    TableRowElement moreFieldRowsTr = new TableRowElement();
    moreFieldRowsTr.id = "moreFieldRows";
    moreFieldRowsTr.classes = ["nodrag", "nodrop"];
    tableBody.nodes.add(moreFieldRowsTr);

    TableCellElement moreFieldRowsTd = new TableCellElement();
    moreFieldRowsTr.nodes.add(moreFieldRowsTd);
    
    _addExtraCells(moreFieldRowsTr);

    LinkElement moreFieldRowsLink = new LinkElement();
    moreFieldRowsLink.classes = ["btn", "btn-small"];
    moreFieldRowsLink.id = moreFieldRowsBtnId;
    moreFieldRowsTd.nodes.add(moreFieldRowsLink);

    Element plusIcon = new Element.tag("i");
    plusIcon.classes= ["icon-plus-sign"];
    moreFieldRowsLink.nodes.add(plusIcon);
        
    //As I added a new Button, I need to reset its action
    Element moreFieldRowsBtn = querySelector("#${moreFieldRowsBtnId}");
    _registerMoreFieldButton(moreFieldRowsBtn);
    //Loads jquerySelector plugin for table drag and drop,
    //When I add a new row, it needs to be reloaded
    js.context["jQuery"]("#logical_field_table").tableDnD();
  }
  
  void _registerMoreFieldButton(Element moreFieldRowsBtn){
    moreFieldRowsBtn.onClick.listen((MouseEvent evt) {
      BaseField dummyBaseField = new BaseField.dummy();
      buildBaseFieldRow(dummyBaseField);
    });
  }
  
  InputElement _addDataType(TableRowElement baseFieldRow){
    TableCellElement dataTypeTd = new TableCellElement();
    baseFieldRow.nodes.add(dataTypeTd);
       
    DivElement controls = new DivElement();
    controls.classes = ["controls"];
    dataTypeTd.nodes.add(controls);
  
    InputElement dataTypeInput =  new Element.tag("input");
    
    dataTypeInput.type = "text";
    dataTypeInput.classes = ["input"];
    dataTypeInput.placeholder = "Tipo";
    if(baseField.name != "")
      dataTypeInput.value = baseField.dataType ;
    
    dataTypeTd.nodes.add(dataTypeInput);
    return dataTypeInput;
  }

 
  void _addExtraCells(TableRowElement moreFieldRowsTr);
  void _addExtraSubCells(TableRowElement moreFieldRowsTr){
    const int NUMBER_OF_HEADERS = 6;
    for(int i = 0; i< NUMBER_OF_HEADERS; i++){
      moreFieldRowsTr.nodes.add(new TableCellElement());
    }
  }
 
  StreamSubscription _addMoreSubFieldsRow(int rowIndex){
    TableRowElement subFieldRow = new TableRowElement();
    subFieldRow.classes = ["more_sub_field_rows_button"];
    //Adds an empty cell element for identation
    subFieldRow.nodes.add(new TableCellElement());
    
    TableCellElement moreFieldRowsTd = new TableCellElement();
    subFieldRow.nodes.add(moreFieldRowsTd);

    LinkElement moreFieldRowsLink = new LinkElement();
    moreFieldRowsLink.classes = ["btn", "btn-small"];
    String dynamicId = "more_field_table_rows_btn${rng.nextInt(999999)}";
    moreFieldRowsLink.id = dynamicId;
    moreFieldRowsTd.nodes.add(moreFieldRowsLink);

    Element plusIcon = new Element.tag("i");
    plusIcon.classes= ["icon-plus-sign"];
    moreFieldRowsLink.nodes.add(plusIcon);
    
    tableBody.nodes.insert(rowIndex, subFieldRow); 
    
    _addExtraSubCells(subFieldRow);
    
    Element moreFieldRowsBtn = querySelector("#${dynamicId}");
    return _registerMoreSubFieldButton(moreFieldRowsBtn, subFieldRow );
  }
  
  StreamSubscription _registerMoreSubFieldButton(Element moreFieldRowsBtn, Element subFieldRow){
    StreamSubscription streamsub = moreFieldRowsBtn.onClick.listen((MouseEvent evt) {
      BaseField dummyBaseField = new BaseField.dummy();
      int rowIndex = tableBody.nodes.indexOf(subFieldRow, 0);
      _createSubField(dummyBaseField, rowIndex);
    });
    return streamsub;
  }
  
  void _createSubField(BaseField baseField, int subFieldRowIndex);
    
   
}