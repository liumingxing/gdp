class Pbs < ActiveRecord::Base
  has_many :propertys, :class_name=>"PbsProperty"
  has_many :nodes, :class_name=>"PbsNode"
end
