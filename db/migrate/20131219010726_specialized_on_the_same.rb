class SpecializedOnTheSame < ActiveRecord::Migration
  def up
    add_column :specializations, :specialized_table_1, :string
    add_column :specializations, :specialized_table_2, :string
    add_column :specializations, :specialized_table_3, :string
    add_column :specializations, :specialized_table_4, :string
    add_column :specializations, :specialized_table_5, :string
    add_column :specializations, :specialized_table_6, :string
    add_column :specializations, :specialized_table_7, :string
    add_column :specializations, :specialized_table_8, :string
    add_column :specializations, :specialized_table_9, :string
    add_column :specializations, :specialized_table_10, :string
  end

  def down
  end
end
