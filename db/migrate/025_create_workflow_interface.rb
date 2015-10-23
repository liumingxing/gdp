#电子表单
class CreateWorkflowInterface < ActiveRecord::Migration
  def self.up
    create_table :workflow_interface, :primary_key => :id do |t|
       t.column :flow_id, :integer                                  #工作流
       t.column :state_name, :string, :limit=>100                   #状态
       t.column :form_id, :integer                                  #表单id
       t.timestamps
    end
  end

  def self.down
    drop_table :workflow_interface
  end
end