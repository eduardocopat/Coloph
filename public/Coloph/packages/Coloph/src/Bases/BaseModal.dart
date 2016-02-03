part of coloph;

abstract class BaseModal
{
  String _modalId;
  var _submitListener;
  bool _submited;
  String type;
  static const EDIT = "EDIT";
  static const CREATE = "CREATE";
  
  
  BaseModal(){}
  
  void showModal(){
    //js.scoped(() {
      //http://stackoverflow.com/questions/10363161/modal-plugin-of-bootstrap-2-is-not-displayed-by-the-center
      //Centers the modal vertically
      num marginToCenterModal = window.pageYOffset - (js.context["jQuery"](_modalId).height() / 2);
      js.context["jQuery"](_modalId).css('margin-top',marginToCenterModal );
      js.context["jQuery"](_modalId).modal('show');
    //});
  }
  
  void hideModal(){
    js.context["jQuery"](_modalId).modal('hide');
  }
  
  void waitForValidationInstance(String submitButtonId, bool validating){
    ButtonElement submitButton = querySelector(submitButtonId);
    Element submitIcon = querySelector("${submitButtonId}_icon");
    CanvasElement canvas = querySelector("#canvas");
    if(validating == true){
      submitButton.disabled = true;
      submitIcon.classes.remove("icon-ok");
      submitIcon.classes.add("fa");
      submitIcon.classes.add("fa-spinner");
      submitIcon.classes.add("fa-spin");
      document.body.style.cursor = 'wait';
    } else {
      submitButton.disabled = false;
      submitIcon.classes.remove("fa");
      submitIcon.classes.remove("fa-spinner");
      submitIcon.classes.remove("fa-spin");
      submitIcon.classes.add("icon-ok");
      document.body.style.cursor = 'default';
    }
    
  }
  
  void _handleSubmit();
  void _clearModal();
  void _populateModelWithInput();
  void _populateInputFromModel();
  
  _mapOldPositions(BaseCanvasModel newModel, BaseCanvasModel oldModel){
    //Map old x and y
    for(BaseField oldBaseField in oldModel.getFields()){
      for(BaseField baseField in newModel.getFields()){
        if(baseField.name == oldBaseField.name){
          baseField.x = oldBaseField.x;
          baseField.y = oldBaseField.y;
        }
        for(BaseField oldBaseSubField in oldBaseField.getFields()){
          for(BaseField baseSubField in baseField.getFields()){
            if(baseSubField.name == oldBaseSubField.name){
              baseSubField.x = oldBaseSubField.x;
              baseSubField.y = oldBaseSubField.y;
            }
          }
        }
      }
    }
  }
}

