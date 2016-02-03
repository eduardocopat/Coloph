class RemoveDataTypeFromTableFields < ActiveRecord::Migration
  def change
    remove_column :table_fields, :data_type
  end
end
