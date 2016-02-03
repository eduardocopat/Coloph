part of coloph;

abstract class Command{
  BaseModel model;
  
  void redo();
  void undo();
}

