class ChangeTypeForDataTypeInTableFields < ActiveRecord::Migration
  def change
    remove_column :table_fields, :type
    add_column :table_fields, :data_type, :string
  end

end
