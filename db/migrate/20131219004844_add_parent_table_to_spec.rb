class AddParentTableToSpec < ActiveRecord::Migration
  def change
    add_column :specializations, :parent_table, :string
  end
end
