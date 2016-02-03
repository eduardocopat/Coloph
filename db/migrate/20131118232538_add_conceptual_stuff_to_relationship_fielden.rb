class AddConceptualStuffToRelationshipFielden < ActiveRecord::Migration
  def change
    add_column :relationship_fields, :composite, :string
    add_column :relationship_fields, :nulls, :string
    add_column :relationship_fields, :multivalued, :string
    add_column :relationship_fields, :derived, :string
  end
end
