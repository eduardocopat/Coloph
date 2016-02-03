class TablesController < ApplicationController
  #load_and_authorize_resource :table

  # GET /tables
  # GET /tables.json
  def index
    @tables = Table.where(:diagram_id => params[:diagram_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tables, :include => { :table_fields => { :include => :table_sub_fields } } }
    end
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    @table = Table.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @table }
    end
  end

  #match "/delete_table_field.json" => "tables#deleteTableField"
  def deleteTableField
    @table = Table.find(params[:table_id])
    @tableField = @table.table_fields.find(params[:table_field_id])

    TableField.destroy(@tableField)

  end

# match "/table.json/changeName" => "tables#changeName"
  def changeName
    #Falta atualizar o nome das relationships que contém essa tabela caso o nome seja mudado?
    @table = Table.find_by_name(params[:old_table_name])
    @table.update_attribute('name',params[:new_table_name])

    respond_to do |format|
        format.json { head :no_content }
    end
  end

  # GET /tables/new
  # GET /tables/new.json
  def new
    @table = Table.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @table }
    end
  end

  # GET /tables/1/edit
  def edit
    @table = Table.find_by_id(params[:table][:id])
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(params[:table])

    respond_to do |format|
      if @table.save
        format.html { redirect_to @table, notice: 'Table was successfully created.' }
        format.json { render json: @table.to_json(:include => { :table_fields => { :include => :table_sub_fields }}), status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tables/1
  # PUT /tables/1.json
  def update
    @table = Table.find_by_id(params[:table][:id])

    respond_to do |format|
      if @table.update_attributes(params[:table])

        format.html { redirect_to @table, notice: 'Table was successfully updated.' }
        format.json { render json: @table.to_json(:include => { :table_fields => { :include => :table_sub_fields }}) }
      else
        format.html { render action: "edit" }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table =  Table.find_by_id(params[:table][:id])
    @table.destroy

    respond_to do |format|
      format.html { redirect_to tables_url }
      format.json { head :no_content }
    end
  end

  # http://stackoverflow.com/questions/10159735/include-has-many-results-in-rest-json-result
  # POST /table.json/validate
  def validate

    table = Table.find_by_id(params[:table][:id])
    if table.nil? == false && table.name == params[:table][:name]

    else
      table = Table.new(params[:table].except(:table_id))
    end

    respond_to do |format|
        if table.valid? == false
          format.json { render json: table.errors, status: :unprocessable_entity }
        else
          format.json { head :no_content }
        end
     end
  end


  #Validates if there is a duplicated table field name
  def duplicated_table_fields_name?
    unique_table_fields = @table.table_fields.uniq {|p| p.name}
    if @table.table_fields.length == unique_table_fields.length
      return false
    else
      return true
    end
  end

end
