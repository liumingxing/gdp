#合约规划
class CreateHygh < ActiveRecord::Migration
  def self.up
    create_table :hygh, :primary_key => :id do |t|
       t.column :project_id, :integer
       t.column :name, :string, :limit=>100                 #节点名称
       t.column :parent_id, :integer                        #父节点id
       t.column :sn, :string, :limit=>100                   #编号
       t.column :fzr, :integer                              #负责人
       t.column :mbcb, :decimal, :precision => 15, :scale => 2    #目标成本
       t.column :nkcb, :decimal, :precision => 15, :scale => 2    #内控成本
       t.column :isht, :integer                             #是合同
       t.column :iszb, :integer                             #招标
       t.column :contractscope, :string, :limit=>100        #范围
       t.column :itemtype, :integer                         #节点类型，分类或子项
       t.column :position, :float                           #节点顺序
       t.column :tmpid, :string, :limit=>100                #grid使用
    end
    
    create_table :hygh_unit, :primary_key => :id do |t|
       t.column :hygh_id, :integer
       t.column :budget_id, :integer
       t.column :name, :string, :limit=>100                 #节点名称
       t.column :cost, :decimal, :precision => 15, :scale => 2
    end
  end

  def self.down
    drop_table :hygh
    drop_table :hygh_unit
  end
end
