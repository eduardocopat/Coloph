class AddDataTypeToSubTableField < ActiveRecord::Migration
  def change
    add_column :table_sub_fields, :data_type, :string
  end
end
