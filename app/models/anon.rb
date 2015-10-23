class Anon < ActiveRecord::Base
  belongs_to :flow, :class_name=>"Workflow", :foreign_key=>"flow_id"
  belongs_to :user, :class_name=>"User", :foreign_key=>"user_id"
  def files
    return [] if !flow
    WorkflowFile.find(:all, :conditions=>"flow_id = '#{flow.id}' and form_id = #{self.id}", :order=>"id")
  end
  
  def flow_name
    flow.name
  end 
end
