part of relationalAlgebra;

class RelationalAlgebraQueryComposer{
  String query; 
  int position;
  
  String queryFirstHalf;
  String querySecondHalf;
  
  static const projectionOperator = "&#928;"; 
  static const selectionOperator = "&sigma;";
  static const unionOperator = "&#8746;";
  static const intersectionOperator = "&#8745;";
  static const differenceOperator = "&#150;";
  static const renameOperator = "&rho;";
  static const naturalJoinOperator = "&#10781;";
  static const leftOuterJoinOperator = "&#10197;";
  static const rightOuterJoinOperator = "&#10198;"; 
  static const fullOuterJoinOperator = "&#10199;";
  static const divisionOperator = "&#247;";
  static const designationOperator = "&#8592;"; //other: &#65513;
  
  
  RelationalAlgebraQueryComposer(){
    
  }
  
  void setQuery(String query){
    this.query = query;
  }
  
  setOperationPosition(int position){
    this.position = position;
  }
  
  void insertProjection(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(projectionOperator + " ()");
  }
  
  void insertSelection(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(selectionOperator + " ()");
  }
  
  void insertUnion(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(unionOperator);
  }
  
  void insertIntersection(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(intersectionOperator);
  }
  
  void insertDifference(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(differenceOperator);    
  }
  
  void insertRename(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(renameOperator);    
  }
  
  void insertNaturalJoin(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(naturalJoinOperator);    
  }
  
  void insertLeftOuterJoin(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(leftOuterJoinOperator);    
  }
  
  void insertRightOuterJoin(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(rightOuterJoinOperator);
  }
  
  void insertFullOuterJoin(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(fullOuterJoinOperator);
  }
  
  void insertDivision(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(divisionOperator);
  }
  
  void insertDesignation(){
    _splitQueryInHalf();
    _insertOperationBetweenHalves(designationOperator);
  }
  
  String getQuery(){
    return query;
  }
  
  void _splitQueryInHalf() {
    queryFirstHalf = query.substring(0, position);
    querySecondHalf = query.substring(position, query.length);
  }
  
  void _insertOperationBetweenHalves(String operation){
    query = queryFirstHalf + operation + querySecondHalf;
  }
  
}