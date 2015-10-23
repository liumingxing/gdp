class CreateWorkitem < ActiveRecord::Migration
  def self.up
    #工作项
    create_table :workitem, :primary_key => :id do |t|
       t.column :user_id, :integer                    #创建者id
       t.column :itemtype, :string, :limit=>100       #工作项类型
       t.column :contract_id, :integer                #合同
       t.column :sn, :string, :limit=>100
       t.column :name, :string, :limit=>100
       t.column :scope, :string, :limit=>100
       t.column :amount, :decimal, :precision => 15, :scale => 2
       t.column :finished, :integer                   #已完成
       t.timestamps
    end
    
    #登记
    create_table :workitem_register, :primary_key => :id do |t|
       t.column :workitem_id, :integer
       t.column :name, :string, :limit=>100
       t.column :contracttype, :string, :limit=>100
       t.column :part_a, :string, :limit=>100
       t.column :part_b, :string, :limit=>100
       t.column :part_c, :string, :limit=>100
       t.column :amount, :decimal, :precision => 15, :scale => 2                #金额
       t.column :start_date, :date                                              #开工时间
       t.column :complete_date, :date                                           #完成时间
       t.column :quality_standard, :string, :limit=>100
       t.column :paymethod, :string, :limit=>100
       t.column :advance_payment, :string, :limit=>100
       t.column :progress_payment, :string, :limit=>100
       t.column :balance_due, :string, :limit=>100
       t.column :principal, :string, :limit=>100
       t.column :comment, :text                       #批注
       t.column :pay_rate, :float                                               #支付比率
       t.column :stop_payment_amount, :decimal, :precision => 15, :scale => 2   #支付金额
       t.column :contract_scope, :text                #合同范围 
    end
    
    #变更
    create_table :workitem_change, :primary_key => :id do |t|
       t.column :workitem_id, :integer
       t.column :name, :string, :limit=>100
       t.column :proposed_company, :string, :limit=>100
       t.column :change_type, :string, :limit=>100                        #变更类型
       t.column :change_reason, :string, :limit=>100                      #变更原因
       t.column :special, :string, :limit=>100                            #专业
       t.column :change_summary, :text                                    #变更内容概要
       t.column :estimate_amount, :decimal, :precision => 15, :scale => 2 #估算金额
       t.column :trial_date, :date                                        #送审日期
       t.column :trial_amount, :decimal, :precision => 15, :scale => 2
       t.column :validate_date, :date
       t.column :validate_amount, :decimal, :precision => 15, :scale => 2 #审定金额
       t.column :principal, :string, :limit=>100                          #负责人
       t.column :effective_date, :date                                    #生效时间
       t.column :memo, :text                                              #备注
    end
    
    #统计
    create_table :workitem_report, :primary_key => :id do |t|
       t.column :workitem_id, :integer
       t.column :name, :string, :limit=>100
       t.column :desc, :string, :limit=>2000
       t.column :trial_date, :date                                            #送审日期
       t.column :pay_before_last_month, :decimal, :precision => 15, :scale => 2   #截止上月累计支付
       t.column :trial_amount, :decimal, :precision => 15, :scale => 2        #送审金额
       t.column :validate_date, :date                                         #审核日期
       t.column :validate_amount, :decimal, :precision => 15, :scale => 2     #审定金额
       t.column :principal, :string, :limit=>100                              #负责人
       t.column :month_minus_amount, :decimal, :precision => 15, :scale => 2  #当月应扣金额
       t.column :total_complete, :decimal, :precision => 15, :scale => 2      #累计完成额
       t.column :buckle_retention, :decimal, :precision => 15, :scale => 2    #扣保留金
       t.column :advance_rebate, :decimal, :precision => 15, :scale => 2      #回扣预付款
       t.column :other_charged, :decimal, :precision => 15, :scale => 2       #其他扣款
       t.column :complete_rate, :string, :limit=>100                          #完成比例
       t.column :memo, :text                                                  #备注
    end
    
    #支付
    create_table :workitem_pay, :primary_key => :id do |t|
      t.column :workitem_id, :integer
      t.column :name, :string, :limit=>100
      t.column :pay_before_last_month, :decimal, :precision => 15, :scale => 2   #截止上月累计支付
      t.column :paytype, :string, :limit=>100                                 #支付类型
      t.column :pay_date, :date                                               #支付时间
      t.column :pay_amount, :decimal, :precision => 15, :scale => 2           #支付金额
      t.column :total_pay_amount, :decimal, :precision => 15, :scale => 2     #累计支付金额
      t.column :principal, :string, :limit=>100                               #负责人
      t.column :pay_reason, :string, :limit=>200                              #支付事由
      t.column :memo, :text                                                   #备注
    end
    
    #结算
    create_table :workitem_clearing, :primary_key => :id do |t|
      t.column :workitem_id, :integer
      t.column :name, :string, :limit=>100
      t.column :desc, :string, :limit=>200
      t.column :trial_date, :date                                             #送审日期
      t.column :trial_amount, :decimal, :precision => 15, :scale => 2         #送审金额
      t.column :clearing_date, :date                                          #结算时间
      t.column :clearing_amount, :decimal, :precision => 15, :scale => 2      #结算金额
      t.column :principal, :string, :limit=>100                               #负责人
      t.column :memo, :text                                                   #备注
    end
    
    #保修
    create_table :workitem_warranty, :primary_key => :id do |t|
      t.column :workitem_id, :integer
      t.column :name, :string, :limit=>100
      t.column :warranty_terms, :string, :limit=>200                          #保修条款
      t.column :warranty_amount, :decimal, :precision => 15, :scale => 2      #保修金额
      t.column :pay_method, :string, :limit=>100                              #付款方式
      t.column :begin_date, :date                                             #开始时间
      t.column :end_date, :date                                               #结束时间
      t.column :principal, :string, :limit=>100                               #负责人
      t.column :memo, :text                                                   #备注
    end
  end

  def self.down
    drop_table :workitem
    drop_table :workitem_register
    drop_table :workitem_change
    drop_table :workitem_report
    drop_table :workitem_pay
    drop_table :workitem_clearing
    drop_table :workitem_warranty
  end
end
