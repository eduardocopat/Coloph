part of coloph;

class SpecializationViewFactory extends ViewFactory{
  
  List<SpecializationView> specializationViews;
  
  SpecializationViewFactory(CanvasRenderingContext2D ctx){
    this.ctx = ctx;
    specializationViews = new List<SpecializationView>();
  }
  
  recreateViews(){
    
  }
  
  setLogicalViews(){
    logicalViews = true;
    conceptualViews = false;
    recreateViews();
  }
  
  setConceptualViews(){
    logicalViews = false;
    conceptualViews = true;
    recreateViews();
  }
  
  SpecializationView newSpecializationView(Specialization specialization, BorderInteractionController borderInteractionController){
    SpecializationView specializationView;
  
    if(logicalViews)
      specializationView = new LogicalSpecializationView(ctx, specialization,borderInteractionController);
    if(conceptualViews)
      specializationView = new ConceptualSpecializationView(ctx, specialization,borderInteractionController);
    
    specializationViews.add(specializationView);
    return specializationView;
  }
}