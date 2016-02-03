class AddNameToDiagram < ActiveRecord::Migration
  def change
    add_column :diagrams, :name, :string
  end
end
