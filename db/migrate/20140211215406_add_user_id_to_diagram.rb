class AddUserIdToDiagram < ActiveRecord::Migration
  def change
    add_column :diagrams, :user_id, :integer
  end
end
