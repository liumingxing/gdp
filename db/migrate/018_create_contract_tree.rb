#合约规划
class CreateContractTree < ActiveRecord::Migration
  def self.up
    create_table :contract_tree, :primary_key => :id do |t|
       t.column :hygh_id, :integer                          #合约规划节点id
       t.column :parent_id, :integer                        #父节点id
       t.column :project_id, :integer                       #项目id
       t.column :name, :string, :limit=>100                 #节点名称
       t.column :treetype, :string, :limit=>100             #树类型，合同、分类
       t.column :position, :integer                         #顺序
    end
  end

  def self.down
    drop_table :contract_tree
  end
end
