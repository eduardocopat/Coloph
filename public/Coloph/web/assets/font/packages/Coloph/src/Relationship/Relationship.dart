part of coloph;

class Relationship extends BaseCanvasModel{
  Table parentTable;
  Table childTable;
  Table ternaryTable;
  
  String dataType;
  String name;
  String nullAllowed;
  
  String parentCardinality;
  String childCardinality;
  String ternaryCardinality;
  String parentRole;
  String childRole;
  bool   identifying;  
  
  bool ternaryConnection;
  
  List<RelationshipField> relationshipFields;
  
  Map<String,Point> nameDiamond; 
  Point nameDiamondMiddlePoint;
  
  static const IDENTIFYING_RELATIONSHIP = "Relacionamento identificador";
  static const NON_IDENTIFYING_RELATIONSHIP =  "Relacionamento não identificador";
  static const MANY_TO_MANY_RELATIONSHIP = "Relacionamento muitos para muitos";
  static const SELF_RELATIONSHIP = "Auto-relacionamento";
  
  static const ALLOW_NULLS = "Permitir";
  static const NOT_ALLOW_NULLS = "Não permitir";
  
  static const ZERO_OR_ONE = "Zero ou um";
  static const ZERO_OR_MANY = "Zero ou vários";
  static const ONE_OR_MANY = "Um ou vários";
  static const ONLY_ONE = "Apenas um";
   
  Relationship(int diagramId, Table parentTable, Table childTable, String dataType, List<RelationshipField> relationshipFields)
      :super(diagramId, 0,0){
    this.parentTable = parentTable;
    this.childTable = childTable;
    this.dataType = dataType;
    if(dataType == Relationship.IDENTIFYING_RELATIONSHIP)
      this.identifying = true;
    
    this.relationshipFields = relationshipFields;
    nameDiamond = new Map<String,Point>();
    
    if(ternaryCardinality == null)
      ternaryCardinality = "(0,1)";
  }
  
  Relationship.fromJsonMap(Map map, Table parentTable, Table childTable, Table ternaryTable):super(0,0,0){
    this.parentTable = parentTable;
    this.childTable = childTable;
    this.ternaryTable = ternaryTable;
    nameDiamond = new Map<String,Point>();
    
    if(map["ternaryCardinality"] == "null")
      ternaryCardinality = "(0,1)";
    
    diagramId = map["diagram_id"];
    id = map["id"];
    x = map["x"];
    y = map["y"];
    width = map["width"];
    height = map["height"];
    name = map["name"];
    identifying = map["identifying"];
    childCardinality = map["child_cardinality"];
    childRole = map["child_role"];
    dataType = map["data_type"];
    nullAllowed = map["null_allowed"];
    parentCardinality = map["parent_cardinality"];
    ternaryCardinality = map["ternary_cardinality"];
    
    relationshipFields = [];
    int i = 0;
    if(map["relationship_fields"] != null){
      while(i < map["relationship_fields"].length){
        RelationshipField relationshipField = new RelationshipField.fromJsonMap(map["relationship_fields"][i]); 
        relationshipFields.add(relationshipField);
        i++;
      }
    }
    
  }
  
  void createNameDiamond(num nameWidth){
    if(parentTable == childTable)
      nameDiamondMiddlePoint = new Point(parentTable.x+(parentTable.width/2), parentTable.y + (parentTable.height*3));
    else
      nameDiamondMiddlePoint = new Point(
        (parentTable.x + childTable.x)/2+(parentTable.width+childTable.width)/2,
        (parentTable.y + childTable.y)/2+(parentTable.height+childTable.height)/2
      );

    updateNameDiamondPoints(nameWidth);
    _calculateRelationshipCanvasModelLocation();

  }
  
  void _calculateRelationshipCanvasModelLocation(){
    /* Code visualization: http://i.imgur.com/bwaKrzO.png */
    Point northToWestMiddlePoint = calculateMiddlePoint(nameDiamond[BorderPoint.NORTH], nameDiamond[BorderPoint.WEST]);
    Point northToEastMiddlePoint = calculateMiddlePoint(nameDiamond[BorderPoint.NORTH], nameDiamond[BorderPoint.EAST]);
    Point southToWestMiddlePoint = calculateMiddlePoint(nameDiamond[BorderPoint.SOUTH], nameDiamond[BorderPoint.WEST]);
    this.x = northToWestMiddlePoint.x-2;
    this.y = northToWestMiddlePoint.y-2;
    this.width = distance2D(northToWestMiddlePoint, northToEastMiddlePoint)+5;
    this.height = distance2D(northToWestMiddlePoint, southToWestMiddlePoint)+5;
  }
  
  void updateNameDiamond(num nameWidth){
    nameDiamondMiddlePoint = new Point((x + (x+width))/2, (y + (y+height))/2); //nameDiamondCenter
    updateNameDiamondPoints(nameWidth);
  }
  
  void updateNameDiamondPoints(num nameWidth){
    nameDiamond.clear();
    //ctx.measureText(relationship.name).width;
    Point northPoint = new Point(nameDiamondMiddlePoint.x, nameDiamondMiddlePoint.y-20); 
    Point westPoint  = new Point(nameDiamondMiddlePoint.x - nameWidth*1.2, nameDiamondMiddlePoint.y);
    Point southPoint = new Point(nameDiamondMiddlePoint.x, nameDiamondMiddlePoint.y+20);
    Point eastPoint  = new Point(nameDiamondMiddlePoint.x + nameWidth*1.2, nameDiamondMiddlePoint.y);
    
    nameDiamond[BorderPoint.NORTH] = northPoint;
    nameDiamond[BorderPoint.WEST] = westPoint;
    nameDiamond[BorderPoint.SOUTH] = southPoint;
    nameDiamond[BorderPoint.EAST] = eastPoint;
  }

  
  Relationship clone(){
    List<RelationshipField> cloneRelationshipFields = new List<RelationshipField>();
    for(RelationshipField relationshipField in this.relationshipFields){
      RelationshipField cloneRelationshipField = new RelationshipField(
          relationshipField.id,
          relationshipField.name, 
          relationshipField.primaryKey, 
          relationshipField.foreignKey,
          relationshipField.nulls,
          relationshipField.composite,
          relationshipField.multivalued,
          relationshipField.derived,
          relationshipField.baseSubFields
      );
      cloneRelationshipField.x = relationshipField.x;
      cloneRelationshipField.y = relationshipField.y;
      cloneRelationshipFields.add(cloneRelationshipField);
      
      List<RelationshipField> clonedSubRelationshipFields = new List<RelationshipField>();
      for(RelationshipField subRelationshipField in relationshipField.baseSubFields){
        RelationshipField cloneSubRelationshipField = new RelationshipField(
            subRelationshipField.id,
            subRelationshipField.name, 
            subRelationshipField.primaryKey, 
            subRelationshipField.foreignKey,
            subRelationshipField.nulls,
            subRelationshipField.composite,
            subRelationshipField.multivalued,
            relationshipField.derived,
            subRelationshipField.baseSubFields
        );
        cloneRelationshipField.x = subRelationshipField.x;
        cloneRelationshipField.y = subRelationshipField.y;
        clonedSubRelationshipFields.add(cloneSubRelationshipField);
      }
      
      cloneRelationshipField.baseSubFields = clonedSubRelationshipFields;
    }
    
    Relationship cloneRelationship = new Relationship(diagramId, parentTable, childTable, dataType, relationshipFields);
    cloneRelationship.id = this.id;
    cloneRelationship.name = this.name;
    
    cloneRelationship.dataType = this.dataType;
    cloneRelationship.nullAllowed = this.nullAllowed;
    cloneRelationship.parentCardinality = this.parentCardinality;
    
    cloneRelationship.childCardinality  = this.childCardinality;
    cloneRelationship.ternaryCardinality = this.ternaryCardinality;
    cloneRelationship.ternaryTable = this.ternaryTable;
    cloneRelationship.parentRole = this.parentRole;
    cloneRelationship.childRole = this.childRole;
    cloneRelationship.identifying = this.identifying;  
    
    cloneRelationship.relationshipFields = cloneRelationshipFields;
    cloneRelationship.x    = this.x;
    cloneRelationship.y = this.y;
    cloneRelationship.width = this.width;
    cloneRelationship.height = this.height;
    
    return cloneRelationship;
  }
   
  
  String toJson([Relationship oldRelationship]){
    Map map = new Map();
    map["relationship"] = new Map();
    map["relationship"]["id"] = id;
    map["relationship"]["x"] = x;
    map["relationship"]["y"] = y;
    map["relationship"]["width"] = width;
    map["relationship"]["height"] = height;
    map["relationship"]["diagram_id"] = diagramId;
    map["relationship"]["identifying"] = identifying;
    map["relationship"]["name"] = name;
    map["relationship"]["data_type"] = dataType;
    map["relationship"]["null_allowed"] = nullAllowed;
    map["relationship"]["parent_table"] = parentTable.name;
    map["relationship"]["child_table"] = childTable.name;
    map["relationship"]["parent_cardinality"] = parentCardinality;
    map["relationship"]["child_cardinality"] = childCardinality;
    if(ternaryTable != null){
      map["relationship"]["ternary_table"] = ternaryTable.name;
      map["relationship"]["ternary_cardinality"] = ternaryCardinality;
    }
    map["relationship"]["parent_role"] = parentRole;
    map["relationship"]["child_role"] = childRole;
    map["relationship"]["identifying"] = identifying;
    
    List<Map> mappedFields = mapFields(oldRelationship);
     
    map["relationship"]["relationship_fields_attributes"] = mappedFields;
    
    return JSON.encode(map);
  }
  
  List<BaseField> getFields(){
    return relationshipFields;
  }
  
}

