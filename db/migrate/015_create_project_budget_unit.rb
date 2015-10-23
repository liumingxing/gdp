#投资管控项目，估算、概算、预算
class CreateProjectBudgetUnit < ActiveRecord::Migration
  def self.up
    create_table :project_budget_unit, :primary_key => :id do |t|
       t.column :project_id, :integer                         #所属项目记录id
       t.column :budget_item_id, :integer                     #预算项id
       t.column :name, :string, :limit=>100                   #名称
       t.column :basis, :string, :limit=>100                  #估算依据
       t.column :unit, :string, :limit=>10                    #单位
       t.column :num, :integer                                #数量
       t.column :price, :decimal, :precision => 15, :scale => 2 #价格
       t.column :rate, :decimal, :precision => 15, :scale => 2, :default=>1  #比率
       t.column :feecode, :string, :limit=>100                #费用代码说明
       t.column :feetype, :string, :limit=>10                 #费用类型
       t.column :desc, :string, :limit=>200                   #描述
       t.timestamps
    end
  end

  def self.down
    drop_table :project_budget_unit
  end
end
