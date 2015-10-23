class Workflow < ActiveRecord::Base
  belongs_to :formtable, :class_name=>"LmxForm"
end
