class AddDiagramIdBaseCanvasModel < ActiveRecord::Migration
  def change
    add_column :tables, :diagram_id, :integer
    add_column :relationships, :diagram_id, :integer
    add_column :specializations, :diagram_id, :integer
  end
end
