class RemoveCardinalityFromRelationship < ActiveRecord::Migration
  def change
    remove_column :relationships, :cardinality
  end

end
