class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :group_id, :integer, :null =>  :true
  end
end
