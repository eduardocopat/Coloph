part of coloph;

class TableField extends BaseField{


  TableField(int id, String name, bool primaryKey, ForeignKey foreignKey, String dataType, bool nulls,
             bool composite, bool multivalued, bool derived, List<BaseField> baseSubFields) : super(0,0){
    this.id = id;
    this.name = name;
    this.primaryKey = primaryKey;
    this.foreignKey = foreignKey;
    this.nulls = nulls;
    this.composite = composite;
    this.multivalued = multivalued;
    this.derived = derived;
    this.dataType = dataType;
    
    if(baseSubFields == null)
      this.baseSubFields = [];
    else
      this.baseSubFields = baseSubFields;
    
    //this.width = 1;
    //this.height = 1;
  }
  
  TableField.fromJsonMap(Map map):super(0,0){
    //if( map["foreignkey"] == true)
    //  return;
    
    diagramId = map["diagram_id"];
    id = map["id"];
    x = map["x"];
    y = map["y"];
    name = map["name"];
    
    this.width = 1;
    this.height = 1;
    
    primaryKey = map["primary_key"];
    foreignKey = new ForeignKey(false, -1);
    
    //foreignKey = new ForeignKey( map["foreignkey"] );
    nulls =  map["nulls"];
    composite =  map["composite"];
    multivalued =  map["multivalued"];
    derived =  map["derived"];
    dataType = map["data_type"];
    
    baseSubFields = [];
    if(map["table_sub_fields"] != null){
      int i = 0;
      while(i < map["table_sub_fields"].length){
        TableField tableField = new TableField.fromJsonMap(map["table_sub_fields"][i]); 
        baseSubFields.add(tableField);
        i++;
      }
    }
  }
  

  
  bool isForeignKey(){
    if(foreignKey.value == true)
      return true;
    else
      return false;
       
  }
  
  String toJson(){
    //return JSON.encode(toMapWithHeader());
  }
  
  Map toMapWithHeader(){
    /*
    Map fieldMap = new Map();
    fieldMap["table_field"] = new Map();
    fieldMap["table_field"]["id"] = id;
    fieldMap["table_field"]["name"] = name;
    fieldMap["table_field"]["x"] = x;
    fieldMap["table_field"]["y"] = y;
    fieldMap["table_field"]["primary_key"] = primaryKey;
    //Isso aqui não funciona ainda, foreignKey...
    //if(tableField.foreignKey.value)
    fieldMap["table_field"]["foreignkey"] = false;
    fieldMap["table_field"]["nulls"] = nulls;
    fieldMap["table_field"]["composite"] = composite;
    fieldMap["table_field"]["multivalued"] = multivalued;
    fieldMap["table_field"]["derived"] = derived;
    
    if(baseSubFields.length != 0){   
      List<Map> mappedSubFields = new List<Map>();
      for(TableField tableField in baseSubFields){
        mappedSubFields.add(tableField.toMap());
      }
      
      fieldMap["table_field"]["table_sub_fields_attributes"] = mappedSubFields;  
    }
    return fieldMap;
    */
  }
  
  Map toMap([bool destroy, BaseField oldBaseField]){
        
    Map fieldMap = new Map();
    if(destroy)
      fieldMap["_destroy"] = 1;
    
    fieldMap["name"] = name;
    fieldMap["id"] = id;
    fieldMap["x"] = x;
    fieldMap["y"] = y;
    fieldMap["primary_key"] = primaryKey;
    fieldMap["foreignkey"] = foreignKey.value;
    fieldMap["nulls"] = nulls;
    fieldMap["composite"] = composite;
    fieldMap["multivalued"] = multivalued;
    fieldMap["derived"] = derived;
    fieldMap["data_type"] = dataType;
    
    
    if(baseSubFields.length != 0){   
      List<Map> mappedSubFields = new List<Map>();
      for(TableField tableField in baseSubFields){
        mappedSubFields.add(tableField.toMap());
      }
      
      if(oldBaseField != null){
        for(TableField oldTableSubField in oldBaseField.getFields()){
          if(this.hasField(oldTableSubField.name) == false)
            mappedSubFields.add(oldTableSubField.toMap(true));
        }
      }
      
      fieldMap["table_sub_fields_attributes"] = mappedSubFields; 
    }
    
    return fieldMap;
  }
  

  
  List<BaseField> getFields(){
    return baseSubFields;
  }
  

}
