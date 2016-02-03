class Relationship < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :name
      t.integer :parent_table_id
      t.integer :child_table_id
      t.string :type
      t.string :null_allowed
      t.string :cardinality

      t.timestamps
    end
  end
end
