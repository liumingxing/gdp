class WorkflowYuezhi < ActiveRecord::Base
  belongs_to :flow, :class_name=>"Workflow"
  
  def my_form
    WorkflowForm.set_table_name("workflow_" + Workflow.find(self.flowid).formtable.code.downcase)
    WorkflowForm.reset_column_information()
    WorkflowForm.find(self.formid)
  end
end

