class AddNewFieldsToTableFields < ActiveRecord::Migration
  def up
    add_column :table_fields, :composite, :boolean
    add_column :table_fields, :multivalued, :boolean
    add_column :table_fields, :derived, :boolean
  end
end
