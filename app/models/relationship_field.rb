class RelationshipField < ActiveRecord::Base
  attr_accessible :name, :x, :y, :primary_key, :nulls, :id, :relationship_id, :composite,
                  :multivalued, :derived, :relationship_sub_fields_attributes
  belongs_to :relationship

  has_many :relationship_sub_fields, :dependent => :destroy
  accepts_nested_attributes_for :relationship_sub_fields, :allow_destroy => true
end
