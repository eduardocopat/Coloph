class AddTernaryToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :ternary_cardinality_min, :string
    add_column :relationships, :ternary_cardinality_max, :string
    add_column :relationships, :ternary_table, :string
  end
end