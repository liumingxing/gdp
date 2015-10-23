#部门
class CreateDepartment < ActiveRecord::Migration
  def self.up
    create_table :department, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100       #名称
       t.column :parent_id, :integer              #上级部门
       t.column :position, :integer               #同级顺序
       t.column :desc, :string, :limit=>200       #描述
       t.column :leader_id, :integer              #负责人
       t.column :parent_leader, :integer          #分管领导
       t.column :phone, :string, :limit=>100      #电话
       t.column :fax, :string, :limit=>100        #传真
    end
  end

  def self.down
    drop_table :department
  end
end