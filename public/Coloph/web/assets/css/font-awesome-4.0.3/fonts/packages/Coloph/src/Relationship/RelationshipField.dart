part of coloph;

class RelationshipField extends BaseField{ 

  RelationshipField(int id, String name, bool primaryKey,  ForeignKey foreignKey, bool nulls,
      bool composite, bool multivalued, bool derived, List<BaseField> baseSubFields) : super(0,0){
    this.id = id;
    this.name = name;
    this.primaryKey = primaryKey;
    this.foreignKey = foreignKey;
    this.nulls = nulls;
    this.composite = composite;
    this.multivalued = multivalued;
    this.derived = derived;
    
    if(baseSubFields == null)
    this.baseSubFields = [];
    else
    this.baseSubFields = baseSubFields;
  }
  
  String toJson(){
    return JSON.encode(toMapWithHeader());
  }
  
  RelationshipField.fromJsonMap(Map map):super(0,0){
    diagramId = map["diagram_id"];
    id = map["id"];
    x = map["x"];
    y = map["y"];
    name = map["name"];
    primaryKey = map["primary_key"];
    foreignKey = new ForeignKey(false, -1);
    
    //foreignKey = new ForeignKey( map["foreignkey"] );
    nulls =  map["nulls"];
    composite =  map["composite"];
    multivalued =  map["multivalued"];
    derived =  map["derived"];
    
    baseSubFields = [];
    if(map["relationship_sub_fields"] != null){
      int i = 0;
      while(i < map["relationship_sub_fields"].length){
        RelationshipField relationshipField = new RelationshipField.fromJsonMap(map["relationship_sub_fields"][i]); 
        baseSubFields.add(relationshipField);
        i++;
      }
    }    
  }
  
  Map toMapWithHeader(){
    Map fieldMap = new Map();
    fieldMap["relationship_field"] = new Map();
    fieldMap["relationship_field"]["primary_key"] = primaryKey;
    fieldMap["relationship_field"]["name"] = name;
    fieldMap["relationship_field"]["id"] = id;
    fieldMap["relationship_field"]["x"] = x;
    fieldMap["relationship_field"]["y"] = y;
    fieldMap["relationship_field"]["nulls"] = nulls;
    fieldMap["relationship_field"]["composite"] = composite;
    fieldMap["relationship_field"]["multivalued"] = multivalued;
    fieldMap["relationship_field"]["derived"] = derived;
    
    if(baseSubFields.length != 0){   
      List<Map> mappedSubFields = new List<Map>();
      for(TableField tableField in baseSubFields){
        mappedSubFields.add(tableField.toMap());
      }
      fieldMap["relationship_field"]["relationship_sub_fields_attributes"] = mappedSubFields;  
    }
    return fieldMap;
    
  }
  
  Map toMap([bool destroy, BaseField oldBaseField]){
   Map fieldMap = new Map();
   
    if(destroy)
      fieldMap["_destroy"] = 1;
    
    fieldMap["primary_key"] = primaryKey;
    fieldMap["name"] = name;
    fieldMap["id"] = id;
    fieldMap["x"] = x;
    fieldMap["y"] = y;
    fieldMap["nulls"] = nulls;
    fieldMap["composite"] = composite;
    fieldMap["multivalued"] = multivalued;
    fieldMap["derived"] = derived;
    
    if(baseSubFields.length != 0){   
      List<Map> mappedSubFields = new List<Map>();
      for(TableField tableField in baseSubFields){
        mappedSubFields.add(tableField.toMap());
      }
      fieldMap["relationship_sub_fields_attributes"] = mappedSubFields;
      
      if(oldBaseField != null){
        for(RelationshipField oldTableSubField in oldBaseField.getFields()){
          if(this.hasField(oldTableSubField.name) == false)
            mappedSubFields.add(oldTableSubField.toMap(true));
        }
      }
      
    }
    
    return fieldMap;
  }
  
  bool hasAPosition(){
    if(x == 0 && y == 0 && width == 0 && height == 0 )
      return false;
    else
      return true;
  }
}
