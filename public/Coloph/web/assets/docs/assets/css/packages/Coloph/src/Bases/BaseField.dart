part of coloph;

class BaseField extends BaseCanvasModel{
  String name;
  String dataType;
  bool primaryKey;
  ForeignKey foreignKey;
  bool nulls;
  bool composite;
  bool multivalued;
  bool derived;
  List<BaseField> baseSubFields;
  
  BaseField(num x, num y): super(0,0,0);
  
  BaseField.dummy():super(0,0,0){
    name = "";
    primaryKey = false;
    foreignKey = new ForeignKey(false,-1);
    nulls = false;
    composite = false;
    multivalued = false;
    derived = false;
    baseSubFields = [];
  }
  
  toJson(){}
  
  List<BaseField> getFields(){
   return baseSubFields;
  }
  
  bool hasAPosition(){
    if(x == 0 && y == 0 && width == 0 && height == 0 )
      return false;
    else
      return true;
  }
  
  Map toMap([bool destroy, BaseField oldBaseField]){
    
  }
 
}