class TableSubField < ActiveRecord::Base
  attr_accessible :foreignkey, :name, :x, :y, :primary_key, :data_type, :nulls, :id, :table_field_id, :composite, :multivalued, :derived
  belongs_to :table_field

  #validates :name, :presence => :true
end
