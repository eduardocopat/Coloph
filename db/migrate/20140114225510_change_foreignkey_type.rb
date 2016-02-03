class ChangeForeignkeyType < ActiveRecord::Migration
  def change
    remove_column :table_fields, :foreignkey
    add_column :table_fields, :foreignkey, :boolean
  end
end
