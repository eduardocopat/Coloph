class TableField < ActiveRecord::Base
  attr_accessible :foreignkey, :name, :x, :y, :primary_key, :data_type, :nulls, :id, :table_id, :composite,
                  :multivalued, :derived, :table_sub_fields_attributes
  belongs_to :table

  validates :name, :presence => :true
  #validates_uniqueness_of :name, :scope => :table_id

  has_many :table_sub_fields, :dependent => :destroy
  accepts_nested_attributes_for :table_sub_fields, :allow_destroy => true
end
