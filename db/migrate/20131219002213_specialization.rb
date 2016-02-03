class Specialization < ActiveRecord::Migration
  def up
    create_table :specializations do |t|
      t.float :x
      t.float :y

      t.timestamps
    end
  end
end
