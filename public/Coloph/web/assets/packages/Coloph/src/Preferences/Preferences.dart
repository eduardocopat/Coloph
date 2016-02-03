part of coloph;

class Preferences{
  
  //Preference list and its default value;
  bool grid;
  bool relationshipNameInLogicalDiagram;

  Preferences() {
    _loadDefaultValues();
  }
  
  _loadDefaultValues(){
    grid = false; 
    relationshipNameInLogicalDiagram = false;
  }
  


}