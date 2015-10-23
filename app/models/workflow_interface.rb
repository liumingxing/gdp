class WorkflowInterface < ActiveRecord::Base
  belongs_to :form, :class_name=>"LmxForm"
end
