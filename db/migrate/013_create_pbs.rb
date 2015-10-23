#项目分解结构
class CreatePbs < ActiveRecord::Migration
  def self.up
    #单项工程结构全模板
    create_table :pbs_template, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                   #名称
       t.column :parent_id, :integer                          #父节点id
       t.column :feetype, :string, :limit=>10                 #费用类型
       t.column :feescope, :string, :limit=>200               #成本项目范围
       t.column :position, :integer, :default=>0              #同级节点排列顺序
       t.column :tmpid, :string, :limit=>100                  #grid使用
    end
    
    create_table :pbs, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                   #名称
       t.column :pbstype, :string, :limit=>10                 #单项工程类型
       t.column :price, :decimal, :precision => 15, :scale => 2         #造价
       t.column :basis, :string, :limit=>10
       t.column :unit, :string, :limit=>10                    #单位
       t.column :desc, :string, :limit=>200                   #描述
    end
    
    create_table :pbs_node, :primary_key => :id do |t|
       t.column :pbs_id, :integer
       t.column :template_id, :integer
       t.column :basis, :string, :limit=>10
       t.column :price, :decimal, :precision => 15, :scale => 2         #造价
       t.column :unit, :string, :limit=>10                    #单位
       t.column :desc, :string, :limit=>200                   #描述
    end
    
    #单项工程属性 
    create_table :pbs_property, :primary_key => :id do |t|
       t.column :pbs_id, :integer
       t.column :name, :string, :limit=>100
       t.column :input_mode, :string, :limit=>100
       t.column :datatype, :string, :limit=>10
       t.column :need, :integer
       t.column :options, :string, :limit=>200
       t.column :unit, :string, :limit=>20
       t.column :position, :integer
    end
  end

  def self.down
    drop_table :pbs_template
    drop_table :pbs
    drop_table :pbs_node
    drop_table :pbs_property
  end
end
