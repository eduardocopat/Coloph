part of coloph;

abstract class BaseCanvasModelController extends BaseController{
  BorderInteractionController borderInteractionController;
  
  void toggle(BaseCanvasModel baseCanvasModel);
  void drag(BaseCanvasModel baseCanvasModel, Point initialCanvasModelPosition, Point initialClientCord, Point newClientCord);
  void resetModelLocation(BaseCanvasModel baseCanvasModel, Map baseFieldsPosition, Point initialCanvasModelPosition);
  void forceUpdateDueToNewPosition(BaseCanvasModel baseCanvasModel);
  void updateCanvasModel(BaseCanvasModel oldModel, BaseCanvasModel newModel){
        
    //Copy the position from old fields    
    for(BaseField newBaseField in newModel.getFields()){
      for(BaseField oldBaseField in oldModel.getFields()){
        if(newBaseField.name == oldBaseField.name){
          newBaseField.x = oldBaseField.x;                  
          newBaseField.y = oldBaseField.y;
          newBaseField.width = oldBaseField.width;
          newBaseField.height = oldBaseField.height;
          newBaseField.foreignKey = oldBaseField.foreignKey;
          
          for(TableField newSubField in newBaseField.getFields()){
            for(TableField oldSubField in oldBaseField.getFields()){
              if(newSubField.name == oldSubField.name){
                newSubField.x = oldSubField.x;                  
                newSubField.y = oldSubField.y;
                newSubField.width = oldSubField.width;
                newSubField.height = oldSubField.height;
                newSubField.foreignKey = oldSubField.foreignKey;
              }
            }
          }
        }
      }
    }

    
    for(BaseField oldBaseField in oldModel.getFields()){
      borderInteractionController.deleteCanvasModel(oldBaseField);
      for(BaseField oldSubBaseField in oldBaseField.getFields())
        borderInteractionController.deleteCanvasModel(oldSubBaseField);
    }
    for(BaseField newBaseField in newModel.getFields()){
      if(newBaseField is TableField){
        TableField tableField = newBaseField;
        if(tableField.isForeignKey())
          continue;
      }
      borderInteractionController.addCanvasModel(newBaseField);
      for(BaseField newSubBaseField in newBaseField.getFields())
        borderInteractionController.addCanvasModel(newSubBaseField);
    }
    borderInteractionController.updateCanvasModel(oldModel, newModel);
  }
  
  _mapFieldsIds(BaseCanvasModel baseCanvasModel, Map bceMap, String baseAttributes, String subBaseAttributes){
    List<BaseField> baseFields = baseCanvasModel.getFields();
    Map baseFieldMaps = bceMap[baseAttributes];
    for(Map baseFieldMap in baseFieldMaps){
       for(BaseField baseField in baseCanvasModel.getFields()){
         if(baseField.name == baseFieldMap["name"]){
           baseField.id = baseFieldMap["id"];
           
           //sub base fields
           Map subBaseFieldMaps = baseFieldMap[subBaseAttributes];
           if(subBaseFieldMaps != null){
             for(Map subBaseMap in subBaseFieldMaps){
               for(BaseField subBaseField in baseField.getFields()){
                 if(subBaseField.name == subBaseMap["name"]){
                   subBaseField.id = subBaseMap["id"];
                 }
               }
             }
           }
           continue;
         }
       }
    }
  }
  
  BaseCanvasModel _getParentModel(BaseCanvasModel baseCanvasModel, BaseCanvasModel viewModel){
      if(baseCanvasModel == viewModel){
        return viewModel;
      }
      
      for(BaseField bf in viewModel.getFields()){
        if(bf == baseCanvasModel){
          return viewModel;
        }
        
        for(BaseField subBf in bf.getFields()){
          if(subBf == baseCanvasModel){
            return viewModel;
          }
        }
      }
  }
}