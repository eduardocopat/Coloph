class TableFieldsController < ApplicationController
  # GET /table_fields
  # GET /table_fields.json
  def index
    @table_fields = TableField.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @table_fields }
    end
  end

  # GET /table_fields/1
  # GET /table_fields/1.json
  def show
    @table_field = TableField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @table_field }
    end
  end

  # GET /table_fields/new
  # GET /table_fields/new.json
  def new
    @table_field = TableField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @table_field }
    end
  end

  # GET /table_fields/1/edit
  def edit
    @table_field = TableField.find(params[:id])
  end

  # POST /table_fields
  # POST /table_fields.json
  def create
    @table_field = TableField.new(params[:table_field])

    respond_to do |format|
      if @table_field.save
        format.html { redirect_to @table_field, notice: 'Table field was successfully created.' }
        format.json { render json: @table_field, status: :created, location: @table_field }
      else
        format.html { render action: "new" }
        format.json { render json: @table_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /table_fields/1
  # PUT /table_fields/1.json
  def update
    @table_field = TableField.find(params[:id])

    respond_to do |format|
      if @table_field.update_attributes(params[:table_field])
        format.html { redirect_to @table_field, notice: 'Table field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @table_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /table_fields/1
  # DELETE /table_fields/1.json
  def destroy
    @table_field = TableField.find(params[:id])
    @table_field.destroy

    respond_to do |format|
      format.html { redirect_to table_fields_url }
      format.json { head :no_content }
    end
  end

  # POST /table_field.json/validate
  def validate
    @table_field = TableField.new(params[:table_field])

    respond_to do |format|
      if @table_field.valid? == false
        format.json { render json: @table_field.errors, status: :unprocessable_entity }
      else
        format.json { head :no_content }
      end
    end
  end
end
