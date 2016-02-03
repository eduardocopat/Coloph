part of coloph;

class Diagram extends BaseModel{
  bool conceptual;
  bool logical;
  bool physical;
  
  Diagram(int id){
    this.id = id;
    conceptual = logical = physical = false;
  }
  
  toJson(){
    Map map = new Map();
    map["diagram"] = new Map();
    map["diagram"]["id"] = this.id;
    return JSON.encode(map);
  }
  getFields(){}
}