class CreateAssignments < ActiveRecord::Migration
  def up
    create_table :assignments do |t|
      t.belongs_to :klass
      t.belongs_to :exercise
    end
  end
end

