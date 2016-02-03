class CreateTableFields < ActiveRecord::Migration
  def change
    create_table :table_fields do |t|
      t.string :name
      t.string :type
      t.boolean :primary_key
      t.boolean :foreign_key

      t.timestamps
    end
  end
end
