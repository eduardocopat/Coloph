class RelationshipsController < ApplicationController
  #load_and_authorize_resource :relationship

  # GET /relationships
  # GET /relationships.json
  def index
    @relationships = Relationship.where(:diagram_id => params[:diagram_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @relationships, :include => { :relationship_fields => { :include => :relationship_sub_fields } } }
    end
  end

  # GET /relationships/1
  # GET /relationships/1.json
  def show
    @relationship = Relationship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @relationship }
    end
  end

  # GET /relationships/new
  # GET /relationships/new.json
  def new
    @relationship = Relationship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @relationship }
    end
  end

  # GET /relationships/1/edit
  def edit
    @relationship = Relationship.find(params[:id])
  end

  # POST /relationships
  # POST /relationships.json
  def create
    @relationship = Relationship.new(params[:relationship])

    respond_to do |format|
      if @relationship.save
        format.html { redirect_to @relationship, notice: 'Relationship was successfully created.' }
        format.json { render json: @relationship.to_json(:include => { :relationship_fields => { :include => :relationship_sub_fields } }), status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /relationships/1
  # PUT /relationships/1.json
  def update
    @relationship = Relationship.find(params[:id])

    respond_to do |format|
      if @relationship.update_attributes(params[:relationship])
        format.html { redirect_to @relationship, notice: 'Relationship was successfully updated.' }
        format.json { render json: @relationship.to_json(:include => { :relationship_fields => { :include => :relationship_sub_fields } }) }
      else
        format.html { render action: "edit" }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.json
  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy

    respond_to do |format|
      format.html { redirect_to relationships_url }
      format.json { head :no_content }
    end
  end

  # POST /relationship.json/validate
  def validate
    @relationship = Relationship.new(params[:relationship])

    respond_to do |format|
      if @relationship.valid? == false
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      else
        format.json { head :no_content }
      end
    end
  end
end
