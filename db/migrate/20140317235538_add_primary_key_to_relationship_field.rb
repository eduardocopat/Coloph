class AddPrimaryKeyToRelationshipField < ActiveRecord::Migration
  def change
    add_column :relationship_fields, :primary_key, :boolean
  end
end


