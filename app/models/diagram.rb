class Diagram < ActiveRecord::Base
  attr_accessible :name, :exercise_solution_id, :diagram_type, :tables_attributes, :relationships_attributes, :specializations_attributes, :user_id

  validates :name, :presence => :true
  enum_attr :diagram_type, %w(Conceptual_entity_relationship_diagram Logical_entity_relationship_diagram), :init=>:Conceptual_entity_relationship_diagram

  has_many :tables
  accepts_nested_attributes_for :tables, :allow_destroy => true

  has_many :relationships
  accepts_nested_attributes_for :relationships, :allow_destroy => true

  has_many :specializations
  accepts_nested_attributes_for :specializations, :allow_destroy => true
end
