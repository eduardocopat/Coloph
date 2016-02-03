class Table < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :name
      t.float :x
      t.float :y

      t.timestamps
    end
  end
end
