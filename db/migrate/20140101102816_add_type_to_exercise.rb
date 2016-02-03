class AddTypeToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :solution_type, :string
  end
end
