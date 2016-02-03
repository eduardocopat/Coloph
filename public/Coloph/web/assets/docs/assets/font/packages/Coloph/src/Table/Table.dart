part of coloph;

class Table extends BaseCanvasModel{
  List<TableField> tableFields;
  String name;
  
  Table(int diagramId, String name, num x, num y, List<TableField> tableFields):super(diagramId, x,y){ //Width and Height are dynamic
    this.name = name;
    
    if(tableFields == null)
      this.tableFields = [];
    else
      this.tableFields = tableFields;
  }
  
  Table.fromJsonMap(Map map):super(0,0,0){
    diagramId = map["diagram_id"];
    id = map["id"];
    x = map["x"];
    y = map["y"];
    name = map["name"];
    
    tableFields = [];
    int i = 0;
    while(i < map["table_fields"].length){
      if(map["table_fields"][i]["foreignkey"] == false){
        TableField tableField = new TableField.fromJsonMap(map["table_fields"][i]); 
        tableFields.add(tableField);
      }
      i++;
    }
  }
  
  void updateLocation(Point newLocation){
    super.updateLocation(newLocation);
  }
  
  bool isWeakEntity(){
    for(TableField tableField in tableFields){
      if(tableField.foreignKey.value == true)
        return true;
    }
    return false;
  }
  
  void deletePrimaryKeyFieldsWithSameName(Table tableToHaveFieldsDeleted){
    List<TableField> fieldsToBeDeleted = new List<TableField>();
    for(TableField parentField in getFields()){
      if(parentField.primaryKey == true){
        for(TableField otherField in tableToHaveFieldsDeleted.getFields()){
          if(otherField.name == parentField.name)
            fieldsToBeDeleted.add(otherField);
        }
      }
    }
    
    for(TableField fieldBeingDeleted in fieldsToBeDeleted){
      tableToHaveFieldsDeleted.getFields().remove(fieldBeingDeleted);
    }
  }
  
  void deleteNonPrimaryKeyFieldsWithSameName(Table tableToHaveFieldsDeleted){
    List<TableField> fieldsToBeDeleted = new List<TableField>();
    for(TableField parentField in getFields()){
      if(parentField.primaryKey == false){
        for(TableField otherField in tableToHaveFieldsDeleted.getFields()){
          if(otherField.name == parentField.name)
            fieldsToBeDeleted.add(otherField);
        }
      }
    }
    
    for(TableField fieldBeingDeleted in fieldsToBeDeleted){
      tableToHaveFieldsDeleted.getFields().remove(fieldBeingDeleted);
    }
  }
  
  String toJson([Table oldTable]){
    Map map = new Map();
    map["table"] = new Map();
    map["table"]["id"] = this.id;
    map["table"]["diagram_id"] = this.diagramId;
    map["table"]["name"] = this.name;
    map["table"]["x"] = this.x;
    map["table"]["y"] = this.y;
    
    List<Map> mappedFields = mapFields(oldTable);
    
    
    
    
    map["table"]["table_fields_attributes"] = mappedFields;  
    return JSON.encode(map);
  }
  
  Map toMap(){
    Map map = new Map();
    map["id"] = this.id;
    map["name"] = this.name;
    map["x"] = this.x;
    map["y"] = this.y;
    
    List<Map> mappedFields = new List<Map>();
    for(TableField tableField in tableFields){
      mappedFields.add(tableField.toMap());
    }
    
    map["table_fields_attributes"] = mappedFields;
    return map;
  }
  
  Table clone(){
    List<TableField> cloneTableFields = new List<TableField>();
    for(TableField tableField in this.tableFields){
      TableField cloneTableField = new TableField(
          tableField.id,
          tableField.name, 
          tableField.primaryKey, 
          tableField.foreignKey,
          tableField.dataType,
          tableField.nulls,
          tableField.composite,
          tableField.multivalued,
          tableField.derived,
          tableField.baseSubFields
      );
      cloneTableField.x = tableField.x;
      cloneTableField.y = tableField.y;
      cloneTableFields.add(cloneTableField);
      
      List<TableField> clonedSubTableFields = new List<TableField>();
      for(TableField subTableField in tableField.baseSubFields){
        TableField cloneSubTableField = new TableField(
            subTableField.id,
            subTableField.name, 
            subTableField.primaryKey, 
            subTableField.foreignKey,
            subTableField.dataType,
            subTableField.nulls,
            subTableField.composite,
            subTableField.multivalued,
            tableField.derived,
            subTableField.baseSubFields
        );
        cloneSubTableField.x = subTableField.x;
        cloneSubTableField.y = subTableField.y;
        clonedSubTableFields.add(cloneSubTableField);
      }
      cloneTableField.baseSubFields = clonedSubTableFields;
    }
    
    Table cloneTable = new Table(this.diagramId, this.name, this.x, this.y, cloneTableFields);
    cloneTable.id = this.id;
    cloneTable.tableFields = cloneTableFields;
    cloneTable.width = this.width;
    cloneTable.height = this.height;
    
    return cloneTable;
  }
  
  List<TableField> getPrimaryKey(){
    List<TableField> primaryKeys = new List<TableField>();
    for(TableField tableField in tableFields){
      if(tableField.primaryKey == true)
        primaryKeys.add(tableField);
    }
    return primaryKeys;
  }
  
  List<TableField> deleteForeignKey(Table parentTable){
    List<TableField> foreignKeys = new List<TableField>(); 
    for(TableField tableField in tableFields){
      if(tableField.foreignKey.foreignTableId == parentTable.id && tableField.foreignKey.value == true)
        foreignKeys.add(tableField);
    }
    for(TableField tableField in foreignKeys)
      tableFields.remove(tableField);
    return foreignKeys;
  }
  
  List<BaseField> getFields(){
    return tableFields;
  }
  
  Map validate(){
    Map errors = new Map();
    String teste = "[existem atributos com nomes duplicados]";
      
    if(areThereFieldsWithDuplicatedNames())
      errors["name"] = teste;
    
    return errors;
  }
  

}