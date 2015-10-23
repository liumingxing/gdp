class ContractTemplate < ActiveRecord::Base
  has_many :nodes, :class_name=>"ContractTemplateNode", :foreign_key=>"template_id", :order=>"position"
end
