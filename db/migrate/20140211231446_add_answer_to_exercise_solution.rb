class AddAnswerToExerciseSolution < ActiveRecord::Migration
  def change
    add_column :exercise_solutions, :answers, :string
  end
end
