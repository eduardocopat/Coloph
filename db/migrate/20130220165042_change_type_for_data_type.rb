class ChangeTypeForDataType < ActiveRecord::Migration
  def change
      remove_column :relationships, :type
    add_column :relationships, :data_type, :string
  end

end
