class AddTableIdToTableFields < ActiveRecord::Migration
  def change
    add_column :table_fields, :table_id, :integer
  end
end
