class CreateTztemplate < ActiveRecord::Migration
  def self.up
    #投资规划模板主表
    create_table :tztemplate, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                   #名称
    end
    
    #投资规划模板从表，存放多棵树形结构
    create_table :tztemplate_node, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                   #名称
       t.column :template_id, :integer                        #单项工程类型
       t.column :parent_id, :integer                          #父节点id
       t.column :feetype, :string, :limit=>10                 #单项工程类型
       t.column :desc, :string, :limit=>200                   #描述
       t.column :position, :integer
    end
  end

  def self.down
    drop_table :tztemplate
    drop_table :tztemplate_node
  end
end
