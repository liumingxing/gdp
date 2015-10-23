#投资管控项目，估算、概算、预算
class CreateProjectBudget < ActiveRecord::Migration
  def self.up
    create_table :project_budget, :primary_key => :id do |t|
       t.column :project_id, :integer                         #所属项目记录id
       t.column :tzgh_id, :integer                            #投资规划id
       t.column :position, :integer, :default=>0              #同级节点排列顺序
       t.column :pbs_id, :integer                             #单项工程id
       t.column :pbs_node_id, :integer                        #单项工程节点id
       t.column :version_id, :integer                         #所属版本号记录id
       t.column :name, :string, :limit=>100, :null=>false     #子项目名称
       t.column :feetype, :string, :limit=>100                #费用类型
       t.column :parent_id, :integer                          #父节点id
       t.column :budgettype, :string, :limit=>10              #投资规划,估算,概算,预算
       t.column :jzgcf, :decimal, :precision => 15, :scale => 2  #建筑工程费
       t.column :azgcf, :decimal, :precision => 15, :scale => 2  #安装程费
       t.column :sbgzf, :decimal, :precision => 15, :scale => 2  #设备购置费
       t.column :qtfy, :decimal, :precision => 15, :scale => 2   #其他费用
       t.column :unit, :string, :limit=>10                       #单位
       t.column :num, :decimal, :precision=>15, :scale=>2        #数量
       t.column :jjzb, :decimal, :precision=>15, :scale=>2       #数量
       t.column :state, :string, :limit=>20                      #状态，审核意见
       t.column :fzr, :integer                                   #负责人
       t.column :shr, :integer                                   #审核人
       t.column :jhsj, :datetime                                 #计划时间
       t.column :wcsj, :datetime                                 #完成时间
       t.column :shyj, :string, :limit=>100                      #审核意见
       t.column :desc, :string, :limit=>200                      #说明
       t.column :properties, :string, :limit=>200                #属性
       t.column :tmpid, :string, :limit=>200                     #临时id
       t.timestamps
    end
  end

  def self.down
    drop_table :project_budget
  end
end
