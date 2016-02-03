class AddConceptualStuffToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :parent_cardinality_min, :string
    add_column :relationships, :parent_cardinality_max, :string
    add_column :relationships, :child_cardinality_min, :string
    add_column :relationships, :child_cardinality_max, :string
    add_column :relationships, :identifying, :string
  end
end
