class FundController < ApplicationController
  #计划
  def plan
    if params[:id]
      @contracts = Contract.paginate :page=>params[:page], :per_page=>20, :conditions=>"project_id = #{session[:pid]} and category_id = #{params[:id]}", :order=>"iscontract desc, id"
    else
      @contracts = Contract.paginate :page=>params[:page], :per_page=>20, :conditions=>"project_id = #{session[:pid]}", :order=>"iscontract desc, id"
    end
  end
  
  #支付
  def pay
    if params[:id]
      @contracts = Contract.paginate :page=>params[:page], :per_page=>20, :conditions=>"project_id = #{session[:pid]} and category_id = #{params[:id]}", :order=>"iscontract desc, id"
    else
      @contracts = Contract.paginate :page=>params[:page], :per_page=>20, :conditions=>"project_id = #{session[:pid]}", :order=>"iscontract desc, id"
    end
  end
  
  #支付计划详情
  def plan_detail
    @contract = Contract.find(params[:id])
  end
  
  #计划支付
  def new_plan
    @contract = Contract.find(params[:id])
    now = Time.new
    0.upto(3) do |i|
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{params[:id]} and year = #{now.year+(now.month+i)/12} and month=#{(now.month+i)%12}")
      instance_eval("@plan#{i+1} = plan")
    end
    render :layout=>"popup"
  end
  
  def create_plan
    now = Time.new
    0.upto(3) do |i|
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{params[:id]} and year = #{now.year+(now.month+i)/12} and month=#{(now.month+i)%12}")
      if !plan
        plan = ContractPayplan.new(params["plan#{i+1}"])
        plan.contract_id = params[:id]
        plan.year = now.year+(now.month+i)/12
        plan.month = (now.month + i)%12
        plan.save
      else
        plan.update_attributes(params["plan#{i+1}"])
      end
    end
    render :text=>"<script>window.parent.location='/fund/plan_detail/#{params[:id]}';</script>"
  end
  
  #实际支付
  def new_pay
    @contract = Contract.find(params[:id])
    now = Time.new
    0.upto(3) do |i|
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{params[:id]} and year = #{now.year+(now.month+i)/12} and month=#{(now.month+i)%12}")
      instance_eval("@plan#{i+1} = plan")
    end
    render :layout=>"popup"
  end
  
  #审定支付
  def new_audit
    @contract = Contract.find(params[:id])
    now = Time.new
    0.upto(3) do |i|
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{params[:id]} and year = #{now.year+(now.month+i)/12} and month=#{(now.month+i)%12}")
      instance_eval("@plan#{i+1} = plan")
    end
    render :layout=>"popup"
  end
  
  def create_pay
    now = Time.new
    0.upto(3) do |i|
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{params[:id]} and year = #{now.year+(now.month+i)/12} and month=#{(now.month+i)%12}")
      if !plan
        plan = ContractPayplan.new(params["plan#{i+1}"])
        plan.contract_id = params[:id]
        plan.year = now.year+(now.month+i)/12
        plan.month = (now.month + i)%12
        plan.save
      else
        plan.update_attributes(params["plan#{i+1}"])
      end
    end
    
    #保存其他
    if params[:other] && params[:other].size > 0
      plan = ContractPayplan.find(:first, :conditions=>"contract_id = #{params[:id]} and year = #{params[:date][:year]} and month=#{params[:date][:month]}")
      if !plan
        plan = ContractPayplan.new()
        plan.contract_id = params[:id]
        plan.year = params[:date][:year]
        plan.month = params[:date][:month]
      end
      plan[params[:field]] = params[:other]
      plan.save
    end
    render :text=>"<script>window.parent.location='/fund/plan_detail/#{params[:id]}';</script>"
  end
end
