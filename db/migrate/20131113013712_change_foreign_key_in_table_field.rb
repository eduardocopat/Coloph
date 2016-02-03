class ChangeForeignKeyInTableField < ActiveRecord::Migration
  def up
    remove_column :table_fields, :foreign_key
    add_column :table_fields, :foreignkey, :string
  end
end
