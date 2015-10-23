class WorkitemPay < ActiveRecord::Base
  belongs_to :user
  belongs_to :workitem
  
  def after_save
    workitem.amount = self.pay_amount
    workitem.save
    workitem.contract.refresh
    
    #添加支付计划记录
    if self.pay_date
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{workitem.contract.id} and year = #{self.pay_date.year} and month = #{self.pay_date.month}")
      if !plan
        plan = ContractPayplan.new
        plan.contract_id = workitem.contract.id
        plan.year = self.pay_date.year
        plan.month = self.pay_date.month
      end
      plan.audit_amount = self.pay_amount
      plan.save
    end
  end
end
