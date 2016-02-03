class ChangeCardinalityMinAndMaxToJustCardinatlity < ActiveRecord::Migration
  def change
    remove_column :relationships, :parent_cardinality_min
    remove_column :relationships, :parent_cardinality_max
    add_column :relationships, :parent_cardinality, :string

    remove_column :relationships, :child_cardinality_min
    remove_column :relationships, :child_cardinality_max
    add_column :relationships, :child_cardinality, :string

    remove_column :relationships, :ternary_cardinality_min
    remove_column :relationships, :ternary_cardinality_max
    add_column :relationships, :ternary_cardinality, :string
  end
end
