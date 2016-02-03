class AddDataTypeToTableField < ActiveRecord::Migration
  def change
    add_column :table_fields, :data_type, :string
  end
end
