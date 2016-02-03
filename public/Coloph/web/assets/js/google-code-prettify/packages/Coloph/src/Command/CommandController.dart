part of coloph;

/** Uses the command pattern concepts*/
class CommandController{
  List<Command> undoStack;
  List<Command> redoStack;
  bool undoing;
  bool redoing;
  
  Element undoButton;
  Element redoButton;
  
  CommandController(){
    undoStack = new List<Command>();
    redoStack = new List<Command>();
    
    undoButton = querySelector("#undo");
    redoButton = querySelector("#redo");
    
    //_handleUndoButton();
    //_handleRedoButton();
    
    //_defineRedoButtonAvailability();
    //_defineUndoButtonAvailability();
    
    undoing = false;
    redoing = false;
  }
  
  void push(Command command){
    if(!undoing){
      undoStack.add(command);
      
      //When we add a new Command to the list, we clear the redo stack    
      if(!redoing)
        redoStack.clear();
      
    }
    undoing = false;
    redoing = false;

    //_defineUndoButtonAvailability();
    //_defineRedoButtonAvailability();
       
  }
  void undo(){
    if(undoStack.length == 0)
     return;
    
    Command undoCommand = undoStack.elementAt(undoStack.length-1);
        
    undoCommand.undo();
    redoStack.add(undoCommand);
    undoStack.removeLast();
    
    undoing = true;
  }
  
  void redo(){
    if(redoStack.length == 0)
      return;
    
    Command redoCommand = redoStack.elementAt(redoStack.length - 1);
    redoCommand.redo();
    redoStack.removeLast();
    
    redoing = true;
  }
  
  void _handleUndoButton(){
    undoButton.onClick.listen((Event evt) {
      undo();
      //_defineUndoButtonAvailability();
     // _defineRedoButtonAvailability();
    });
  }
  
  void _handleRedoButton(){
    redoButton.onClick.listen((Event evt) {
      redo();
    //  _defineUndoButtonAvailability();
    //  _defineRedoButtonAvailability();
    });
  }
    
  void _defineUndoButtonAvailability(){
    Element undoIcon = querySelector("#undo_icon");
    if(undoStack.length > 0){
     undoIcon.classes.add('icon-avaiable');
     undoIcon.classes.remove('icon-not-avaiable');
    }
    else{
     undoIcon.classes.remove('icon-avaiable');
     undoIcon.classes.add('icon-not-avaiable');
    }
  }
  
  void _defineRedoButtonAvailability(){
    Element redoIcon = querySelector("#redo_icon");
    if(redoStack.length > 0){
     redoIcon.classes.add('icon-avaiable');
     redoIcon.classes.remove('icon-not-avaiable');
    }
    else{
     redoIcon.classes.remove('icon-avaiable');
     redoIcon.classes.add('icon-not-avaiable');
    }
  }
}