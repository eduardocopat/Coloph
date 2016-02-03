class AddRolesToRelationsihp < ActiveRecord::Migration
  def change
    add_column :relationships, :parent_role, :string
    add_column :relationships, :child_role, :string
  end
end
