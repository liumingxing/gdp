#合约规划
class CreateContractTemplate < ActiveRecord::Migration
  def self.up
    create_table :contract_template, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                 #合约规划模板名称
    end
    
    create_table :contract_template_node, :primary_key => :id do |t|
       t.column :template_id, :integer                      #模板id
       t.column :name, :string, :limit=>100                 #节点名称
       t.column :parent_id, :integer                        #父节点id
       t.column :itemtype, :integer                         #节点类型，分类或子项
       t.column :position, :float                           #节点顺序
       t.column :tmpid, :string, :limit=>100                #grid使用
       t.column :desc, :string, :limit=>100                 #描述
    end
  end

  def self.down
    drop_table :contract_template
    drop_table :contract_template_node
  end
end
