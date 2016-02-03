class ChangeExerciseSolutionAddQueryExerciseAnswer < ActiveRecord::Migration
  def change
    remove_column :exercise_solutions, :answers
  end
end
