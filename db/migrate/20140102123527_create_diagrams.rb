class CreateDiagrams < ActiveRecord::Migration
  def change
    create_table :diagrams do |t|
      t.string :diagram_type
      t.belongs_to :exercise_solution

      t.timestamps
    end
  end
end
