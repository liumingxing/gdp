#部门
class CreateBudgetFile < ActiveRecord::Migration
  def self.up
    create_table :budget_file, :primary_key => :id do |t|
       t.column :project_id, :integer             #项目id
       t.column :budget_id, :integer              #预算项id
       t.column :budget_type, :integer            #概预
       t.column :path, :string, :limit=>300       #文件路径
       t.column :user_id, :integer                #发布人
       t.timestamps
    end
  end

  def self.down
    drop_table :budget_file
  end
end