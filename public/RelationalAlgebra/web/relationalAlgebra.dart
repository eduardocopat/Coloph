import 'dart:html';
import 'lib/relationalAlgebraLib.dart';

TextAreaElement relationalAlgebraQueryTextArea;
RelationalAlgebraQueryComposer queryComposer;
int operationPosition;

const queryExerciseAnswerAnswerTextAreaId = "#query_exercise_answer_answer";
const relationalAlgebraQueryDiv = "#query_exercise_answer_answer_div";

void main() {
  relationalAlgebraQueryTextArea = querySelector(queryExerciseAnswerAnswerTextAreaId);
  queryComposer = new RelationalAlgebraQueryComposer();
  _setTextAreaFont();
  print("Teste");
  createHandlers();
}

void _setTextAreaFont() {
  relationalAlgebraQueryTextArea.style.fontFamily = "cambria";
  relationalAlgebraQueryTextArea.style.fontSize = "18px";
}

void setTextAreaQueryContent(String query){
  relationalAlgebraQueryTextArea.remove(); //remove from HTML
  
  //We need to clone in order to refresh innerHTML. In this way, we can update the query content  
  _cloneRelationalAlgebraQueryTextArea();
  relationalAlgebraQueryTextArea.innerHtml = query;
  querySelector(relationalAlgebraQueryDiv).children.add(relationalAlgebraQueryTextArea);
}

void _cloneRelationalAlgebraQueryTextArea() {
  TextAreaElement clonedRelationalAlgebraQueryTextArea = new TextAreaElement();
  clonedRelationalAlgebraQueryTextArea.id = relationalAlgebraQueryTextArea.id;
  clonedRelationalAlgebraQueryTextArea.cols = relationalAlgebraQueryTextArea.cols;
  clonedRelationalAlgebraQueryTextArea.rows = relationalAlgebraQueryTextArea.rows;
  clonedRelationalAlgebraQueryTextArea.classes = relationalAlgebraQueryTextArea.classes;
  clonedRelationalAlgebraQueryTextArea.name = relationalAlgebraQueryTextArea.name;
  relationalAlgebraQueryTextArea = clonedRelationalAlgebraQueryTextArea;
  _setTextAreaFont();
}

String getTextAreaQueryContent(){
  TextAreaElement rrelationalAlgebraQueryTextArea = querySelector(queryExerciseAnswerAnswerTextAreaId);
  return relationalAlgebraQueryTextArea.value;
}

void createHandlers(){
  querySelector("#projection_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertProjection();
    _postProcessQuery();
  });
  querySelector("#selection_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertSelection();
    _postProcessQuery();
  });
  querySelector("#union_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertUnion();
    _postProcessQuery();
  });
  querySelector("#intersection_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertIntersection();
    _postProcessQuery();
  });  
  querySelector("#difference_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertDifference();
    _postProcessQuery();
  });  
  querySelector("#division_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertDivision();
    _postProcessQuery();
  });
  querySelector("#natural_join_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertNaturalJoin();
    _postProcessQuery();
  });
  querySelector("#left_outer_join_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertLeftOuterJoin();
    _postProcessQuery(); 
  });
  querySelector("#right_outer_join_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertRightOuterJoin();
    _postProcessQuery();    
  });
  querySelector("#full_outer_join_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertFullOuterJoin();
    _postProcessQuery();
  });

  querySelector("#rename_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertRename();
    _postProcessQuery();
  });
  querySelector("#designation_operator_button").onClick.listen((Event evt) {
    _preProcessQuery();
    queryComposer.insertDesignation();
    _postProcessQuery();
  });
}

void _postProcessQuery() {
  setTextAreaQueryContent(queryComposer.getQuery());
  relationalAlgebraQueryTextArea.focus();
  relationalAlgebraQueryTextArea.setSelectionRange(operationPosition+1, operationPosition+1);
}

void _preProcessQuery() {
  operationPosition = relationalAlgebraQueryTextArea.selectionStart;
  queryComposer.setQuery(getTextAreaQueryContent());
  queryComposer.setOperationPosition(operationPosition);
}



