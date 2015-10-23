class Contract < ActiveRecord::Base
  belongs_to :category, :class_name=>"Hygh", :foreign_key=>"category_id"
  has_many :plans, :class_name=>"ContractPayplan", :order=>"year, month"
  
  #重新计算合同金额
  def refresh
    self.contract_amount = 0
    self.stop_pay_amount = 0
    for item in workitems("register")
      self.contract_amount += item.amount.to_f
      self.stop_pay_amount += item.register.stop_payment_amount
    end    
    
    self.change_amount = 0
    for item in workitems("change")
      self.change_amount += item.amount.to_f
    end
    
    self.total_complete = 0
    for item in workitems("report")
      self.total_complete += item.amount.to_f
    end
    
    self.pay_amount = 0
    for item in workitems("pay")
      self.pay_amount += item.amount.to_f
    end
    
    self.clearing_amount = 0
    for item in workitems("clearing")
      self.clearing_amount += item.amount.to_f
    end
    
    self.warranty_amount = 0
    for item in workitems("warranty")
      self.warranty_amount += item.amount.to_f
    end
    
    self.save
  end
  
  def workitems(code)
    Workitem.find(:all, :conditions=>"contract_id = #{self.id} and itemtype = '#{code}'")
  end
  
  #本月审批支付
  def audit_pay_of_this_month(year=Time.new.year, month=Time.new.month)
    result = 0
    for plan in plans
      result += plan.audit_amount.to_f if plan.year == year && plan.month == month
    end

    result
  end
  
  #本月实际支付
  def pay_of_this_month(year=Time.new.year, month=Time.new.month)
    result = 0
    for plan in plans
      result += plan.pay_amount.to_f if plan.year == year && plan.month == month
    end

    result
  end
  
  #截止上月审批金额
  def audit_pay_before_this_month
    result = 0
    now = Time.new
    for plan in plans
      result += plan.audit_amount.to_f if plan.year <= now.year && plan.month <= now.month
    end

    result
  end
  
  #截止上月支付金额
  def pay_before_this_month
    result = 0
    now = Time.new
    for plan in plans
      if plan.year <= now.year && plan.month < now.month
        result += plan.pay_amount.to_f
      end
    end
    result
  end
  
  #月度支付计划金额
  def plan_amount(date = Time.new)
    result = 0
    for plan in ContractPayplan.find(:all, :conditions=>"contract_id = #{self.id} and year = #{date.year} and month = #{date.month}")
      result += plan.plan_amount
    end
    result
  end
  
  #月度支付审批金额
  def audit_amount(date = Time.new)
    result = 0
    for plan in ContractPayplan.find(:all, :conditions=>"contract_id = #{self.id} and year = #{date.year} and month = #{date.month}")
      result += plan.audit_amount
    end
    result
  end
  
  def x_amount(field, date = Time.new)
    result = nil
    for plan in ContractPayplan.find(:all, :conditions=>"contract_id = #{self.id} and year = #{date.year} and month = #{date.month}")
      result = result.to_f + plan[field].to_f
    end
    result
  end
  
  #累计审定金额
  def total_audit_amount
    result = 0
    for plan in ContractPayplan.find(:all, :conditions=>"contract_id = #{self.id}")
      result += plan.audit_amount.to_f
    end
    result 
  end
  
  
  
  #累计计划金额
  def total_plan_amount
    result = 0
    for plan in ContractPayplan.find(:all, :conditions=>"contract_id = #{self.id}")
      result += plan.plan_amount.to_f
    end
    result 
  end
  
  #累计支付金额
  def total_pay_amount
    result = 0
    for plan in ContractPayplan.find(:all, :conditions=>"contract_id = #{self.id}")
      result += plan.pay_amount.to_f
    end
    result 
  end
  
  def state
    if contract_amount == 0
      "启动"
    elsif clearing_amount == 0
      "执行"
    else
      "完成"
    end
  end
end
