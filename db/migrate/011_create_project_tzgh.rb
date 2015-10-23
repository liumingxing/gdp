#投资管控项目
class CreateProjectTzgh < ActiveRecord::Migration
  def self.up
    create_table :project_tzgh, :primary_key => :id do |t|
       t.column :project_id, :integer                         #所属项目记录id
       t.column :position, :integer, :default=>0              #同级节点排列顺序
       t.column :pbs_id, :integer                             #单项工程id
       t.column :pbs_node_id, :integer                        #单项工程节点id
       t.column :name, :string, :limit=>100, :null=>false     #子项目名称
       t.column :parent_id, :integer                          #父节点id
       t.column :feetype, :string, :limit=>10                 #费用类型:工程费用，其他   
       t.column :feescope, :string, :limit=>100               #成本项目范围
       t.column :template_node_id, :integer                   #模板节点id
       t.column :tmpid, :string, :limit=>200                  #临时id
       t.timestamps
    end
  end

  def self.down
    drop_table :project_tzgh
  end
end
