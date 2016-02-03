class CreateTableSubFields < ActiveRecord::Migration
  def up
    create_table :table_sub_fields do |t|
      t.string  :name
      t.integer :table_field_id
      t.float   :x
      t.float   :y
      t.boolean :primary_key
      t.boolean :foreignkey
      t.boolean :nulls
      t.boolean :composite
      t.boolean :multivalued
      t.boolean :derived
    end
  end

  def down
  end
end

