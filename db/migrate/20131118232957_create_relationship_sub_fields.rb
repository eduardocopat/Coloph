class CreateRelationshipSubFields < ActiveRecord::Migration
    def up
      create_table :relationship_sub_fields do |t|
        t.string  :name
        t.integer :relationship_field_id
        t.float   :x
        t.float   :y
        t.boolean :nulls
        t.boolean :composite
        t.boolean :multivalued
        t.boolean :derived
      end
    end

    def down
    end
end
