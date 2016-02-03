class AddDiagramIdToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :diagram_id, :integer
  end
end
