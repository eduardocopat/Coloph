part of coloph;

class Specialization extends BaseCanvasModel{
  Table parentTable;
  List<Table> specializedTables;
  
  Specialization(int diagramId, Table parentTable, Table specializedTable):super(diagramId, 0,0){
    this.parentTable = parentTable;
    specializedTables = new List<Table>();
    specializedTables.add(specializedTable);
    _setDefaultSize();
    _createInitialLocation(parentTable, specializedTable);
  }
  
  Specialization.fromJsonMap(Map map, Table parentTable, List<Table> specializedTables ):super(0,0,0){
    diagramId = map["diagram_id"];
    id = map["id"];
    x = map["x"];
    y = map["y"];
    _setDefaultSize();
    this.parentTable = parentTable;
    this.specializedTables = specializedTables;

  }
  
  _setDefaultSize(){
    this.width = 30;
    this.height = 30;
  }
  
  void _createInitialLocation(Table parentTable, Table specializedTable){
    this.x = (parentTable.x + specializedTable.x)/2;
    this.y = (parentTable.y + specializedTable.y)/2;
  }
  
  List<BaseField> getFields(){
    return new List<BaseField>();
  }
  
  void addSpecializedTable(Table table){
    specializedTables.add(table);
  }
  
  String toJson(){
    Map map = new Map();
    map["specialization"] = new Map();
    map["specialization"]["diagram_id"] = this.diagramId;
    map["specialization"]["id"] = this.id;
    map["specialization"]["x"] = this.x;
    map["specialization"]["y"] = this.y;
    map["specialization"]["parent_table"] = parentTable.name;
    
    //yes, shame on me on doing this
    //but I was in a hurry and stressed, if one day I'll have to deal this, fuck me.
    int i = 1;
    for(Table table in specializedTables){
      map["specialization"]["specialized_table_${i}"] = table.name;
      i++;
    }
        
        
    return JSON.encode(map);
  }
}