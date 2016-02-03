class Specialization < ActiveRecord::Base
   attr_accessible :id, :diagram_id, :x, :y, :parent_table,
        :specialized_table_1,
       :specialized_table_2,
       :specialized_table_3,
       :specialized_table_4,
       :specialized_table_5,
       :specialized_table_6,
       :specialized_table_7,
       :specialized_table_8,
       :specialized_table_9,
       :specialized_table_10

   belongs_to :diagram
end
