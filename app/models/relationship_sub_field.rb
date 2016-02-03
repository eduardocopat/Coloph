class RelationshipSubField < ActiveRecord::Base
  attr_accessible :name, :x, :y , :nulls, :id, :relationship_field_id, :composite, :multivalued, :derived
  belongs_to :relationship_field
end
