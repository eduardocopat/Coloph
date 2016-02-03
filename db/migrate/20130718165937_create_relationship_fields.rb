class CreateRelationshipFields < ActiveRecord::Migration
  def change
    create_table :relationship_fields do |t|
      t.string  :name
      t.float   :x
      t.float   :y
      t.integer :relationship_id

      t.timestamps
    end

    add_column :table_fields, :x, :float
    add_column :table_fields, :y, :float
  end
end
