class Relationship < ActiveRecord::Base
  attr_accessible :id, :x, :y, :width, :height,
                  :diagram_id, :name, :parent_table , :child_table, :data_type,  :null_allowed,
                  :relationship_fields_attributes, :relationship_fields,
                  :parent_cardinality,
                  :child_cardinality,
                  :ternary_table, :ternary_cardinality,
                  :identifying,
                  :parent_role, :child_role


  belongs_to :diagram
  has_many :relationship_fields, :dependent => :destroy
  accepts_nested_attributes_for :relationship_fields, :allow_destroy => true
  validates :name, :presence => :true
end
