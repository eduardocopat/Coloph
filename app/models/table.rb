class Table < ActiveRecord::Base
  attr_accessible  :id, :diagram_id, :name, :x, :y, :table_fields_attributes, :table_fields

  validates :name, :presence => :true
  validates :name, :uniqueness => {:scope => :diagram_id}

  belongs_to :diagram
  has_many :table_fields, :dependent => :destroy
  accepts_nested_attributes_for :table_fields, :allow_destroy => true


  #validates :table_fields, :presence  => { :message => "E necessario pelo menos um campo." }


end
