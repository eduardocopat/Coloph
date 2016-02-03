class Add < ActiveRecord::Migration
  def change
    add_column :table_fields, :nulls, :boolean
  end
end
