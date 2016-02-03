class AddXAndY < ActiveRecord::Migration
  def change
    add_column :relationships, :x, :float
    add_column :relationships, :y, :float
  end
end
