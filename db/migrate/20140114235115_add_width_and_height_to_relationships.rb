class AddWidthAndHeightToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :width, :float
    add_column :relationships, :height, :float
  end
end
