class ChangeIdentifyingToBoolean < ActiveRecord::Migration
 def change
   remove_column :relationships, :identifying
   add_column :relationships, :identifying, :boolean
 end
end
