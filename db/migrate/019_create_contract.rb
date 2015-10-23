#合约规划
class CreateContract < ActiveRecord::Migration
  def self.up
    create_table :contract, :primary_key => :id do |t|
       t.column :category_id, :integer              #类别id
       t.column :project_id, :integer               #项目id
       t.column :name, :string, :limit=>200         #合同名称
       t.column :begintime, :date                   #开始时间
       t.column :endtime,   :date                   #完成时间
       t.column :contracttype, :string, :limit=>20  #合同类型
       t.column :paymethod, :string, :limit=>20     #变更支付方式
       t.column :contractscope, :string, :limit=>200  #承包范围 
       t.column :iscontract, :integer, :default=>1  # 1=>合同 0=>费用
       t.column :contract_amount, :decimal, :precision => 15, :scale => 4, :default=>0   #合同金额
       t.column :change_amount, :decimal, :precision => 15, :scale => 4, :default=>0     #变更金额
       t.column :clearing_amount, :decimal, :precision => 15, :scale => 4, :default=>0   #结算金额
       t.column :pay_amount, :decimal, :precision => 15, :scale => 4, :default=>0        #支付金额
       t.column :pay_rate, :float                                                        #支付比率
       t.column :detention_amount, :decimal, :precision => 15, :scale => 4, :default=>0  #预留金额
       t.column :warranty_amount, :decimal, :precision => 15, :scale => 4, :default=>0   #质保金额
       t.column :current_payamount, :decimal, :precision => 15, :scale => 4, :default=>0 #本期审定支付
       t.column :payment, :decimal, :precision => 15, :scale => 4, :default=>0           #累计支付
       t.column :current_payment, :decimal, :precision => 15, :scale => 4, :default=>0   #本期支付
       t.column :clearing_finished, :decimal, :precision => 15, :scale => 4, :default=>0 #结算完成
       t.column :stop_pay_amount, :decimal, :precision => 15, :scale => 4, :default=>0    #止付金额
       t.column :total_complete, :decimal, :precision => 15, :scale => 4, :default=>0    #已完成，统计使用
       t.column :target_amount, :decimal, :precision => 15, :scale => 4, :default=>0     #内控成本
       t.column :cost_source, :string, :limit=>100                                       #资金来源
       t.column :company_name, :string, :limit=>100                                      #公司名称
       t.column :memo, :text                                                             #备注
    end
    
    #合同参与人
    create_table :contract_user, :id => false  do |t|
       t.column :contract_id, :integer
       t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :contract
    drop_table :contract_user
  end
end
