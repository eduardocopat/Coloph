class ChangeParentAndChildTableIdsForNames < ActiveRecord::Migration
  def up
    add_column :relationships, :parent_table, :string
    add_column :relationships, :child_table, :string

    remove_column :relationships, :parent_table_id
    remove_column :relationships, :child_table_id
  end

end
