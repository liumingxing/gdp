#合约规划
class CreateContractPayplan < ActiveRecord::Migration
  def self.up
    create_table :contract_payplan, :primary_key => :id do |t|
       t.column :contract_id, :integer                                  #合同id
       t.column :year, :integer                                         #年份
       t.column :month, :integer                                        #月份
       t.column :plan_amount, :decimal, :precision => 15, :scale => 2   #计划支付
       t.column :audit_amount, :decimal, :precision => 15, :scale => 2  #审定支付
       t.column :pay_amount, :decimal, :precision => 15, :scale => 2    #实际支付
       t.timestamps
    end
  end

  def self.down
    drop_table :contract_payplan
  end
end
