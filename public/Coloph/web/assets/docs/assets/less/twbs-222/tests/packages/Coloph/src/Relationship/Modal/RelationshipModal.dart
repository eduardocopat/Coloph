part of coloph;

abstract class RelationshipModal extends BaseModal{
  Relationship relationship;
  RelationshipController relationshipController;
  bool _canceled;
  String modelingType;
      
  RelationshipModal(Relationship relationship, String modalType, RelationshipController relationshipController, String modalId){
    this.relationship = relationship;
    this.relationshipController = relationshipController;
    this._canceled = false;
    this._modalId = modalId;
    _defineModalType(modalType);
    _clearModal(); 
    _populateInputFromModel();
    _handleSubmit();
    setModelingType();
    
    showModal();
    
  }
  
  void setModelingType();
  
  _defineModalType(String modalType){
    //If there is no table Id assigned, then we're creating a new table.
    if(modalType == BaseModal.CREATE)
      type = BaseModal.CREATE;
    else
      type = BaseModal.EDIT;
  }
  
  
  _handleSubmit(){
    _submitListener = querySelector(("${_modalId}_submit")).onClick.listen((Event evt) {
       waitForValidationInstance("${_modalId}_submit", true);
      _clearHelpSpans();
      _clearControlGroupDivs();
      _populateModelWithInput();
      relationshipController.validate(relationship, this);
    });
  }
  
  receiveErrorsFromValidation(Map errors){
    waitForValidationInstance("${_modalId}_submit", false);
    //It is needed to cancel the listener on the submit or it will continues to listen everytime the
    //user clicks it. This may generate several instances of the object in the database.
    //cancelSubmitListener();
    
    if(errors.length == 0){
      if(type == BaseModal.CREATE){
        relationshipController.createRelationship(relationship);
      }
      else
        relationshipController.updateRelationship(relationship);
      hideModal();
    }
    else
      _displayErrors(errors);
  }

  cancelSubmitListener(){
    if(_canceled == false){
        _submitListener.cancel();
        _canceled = true;
    }
  }

  
  _populateInputFromModel();
  
  _populateModelWithInput();
  
  _displayErrors(Map errors){
    _clearControlGroupDivs();
    _clearHelpSpans();
    
    for(String key in errors.keys){
      List messagesOfKey = errors[key];
      String fullMessage = messagesOfKey[0];
      for(int i = 1; i < messagesOfKey.length; i++){
        fullMessage = "$fullMessage, ${messagesOfKey[i]}";
      }
      
      //Query the input with error
      InputElement inputWithError = querySelector("#${modelingType}_relationship_${key}");
      
      SpanElement helpSpan = new SpanElement();
      helpSpan.classes = ["help-inline"];
      helpSpan.text = fullMessage;

      //Adds a span in-line in its parent, with the error information
      inputWithError.parent.nodes.add(helpSpan);
      
      //Adds the error class to the div
      DivElement controlGroupDiv = inputWithError.parent.parent;
      controlGroupDiv.classes = ["control-group", "error"];
    }
  }
  
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
  
  _clearModal();
  
  _addRelationshipFieldRow(RelationshipField relationshipField);
}
