part of coloph;


//Notes: Uses the singleton Preferences
class PreferencesModal extends BaseModal{
  
    PreferencesController preferencesController;
    Preferences preferences;
    
    CheckboxInputElement grid;
    CheckboxInputElement relationshipNameLogicalInputelement;
  
    PreferencesModal(PreferencesController preferencesController, Preferences preferences){
      this.preferencesController = preferencesController;
      this.preferences = preferences;
      _modalId = "#preferences_modal";
      
      _loadPreferences();
      showModal();
      _handleSubmit();  
    }
    
    _handleSubmit(){
      querySelector("#preferences_submit").onClick.listen((Event evt) {
        preferences.grid = grid.checked;
        preferences.relationshipNameInLogicalDiagram = relationshipNameLogicalInputelement.checked;
        hideModal();
        preferencesController.executePreferencesChosen();
      });
      
     
    }
    
    _loadPreferences(){
      grid = querySelector("#grid_preference");
      grid.checked = preferences.grid;
      
      relationshipNameLogicalInputelement = querySelector("#relationship_name_logical_preference");
      relationshipNameLogicalInputelement.checked = preferences.relationshipNameInLogicalDiagram;
    }
    
    _clearModal(){}
    _populateModelWithInput(){}
    _populateInputFromModel(){}
    
}