require 'rexml/document'
class ReportController < ApplicationController
  def index
    render :layout=>"popup"
  end
  
  def test_data
    users = User.find(:all)
    puts records_to_xml(users)
    render :text=>records_to_xml(users)
  end
  
  #合同汇总表
  def contract
    contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]} and iscontract = 1", :order=>"category_id, contracttype")
    doc = REXML::Document.new("<xml></xml>")
    for c in contracts
      element = doc.root.add_element "row"
      element.attributes["cid"]              = c.category.id
      element.attributes["cname"]            = c.category.name
      element.attributes["name"]             = c.name
      element.attributes["company_name"]     = c.company_name
      element.attributes["contracttype"]     = c.contracttype
      element.attributes["contract_amount"]  = c.contract_amount
      element.attributes["change_amount"]    = c.change_amount
      element.attributes["clearing_amount"]  = c.clearing_amount
      element.attributes["pay_before_this_month"] = c.pay_before_this_month
      element.attributes["pay_of_this_month"]= c.pay_of_this_month
      element.attributes["total_pay_amount"] = c.total_pay_amount
    end
    
    str = ''
    doc.write(str)
    puts str
    render :text=>str
  end
  
  #变更汇总表
  def change
    contracts = Contract.find_by_sql %! SELECT workitem_change.name, contract.name AS contract_name, contract.id AS contract_id, contract.contracttype, estimate_amount,
validate_amount, estimate_amount-validate_amount AS hj_amount, (estimate_amount-validate_amount)/estimate_amount AS hj_rate, 
effective_date, trial_date, validate_date, workitem_change.memo, special
FROM workitem_change, workitem
LEFT JOIN contract ON workitem.contract_id = contract.id 
WHERE workitem_change.workitem_id = workitem.id and contract.project_id = #{session[:pid]}
ORDER BY contract.contracttype, contract.id !
    render :text=>records_to_xml(contracts)
  end
  
  #计量汇总表
  def report
    contracts = Contract.find_by_sql %! SELECT contract.contracttype, contract.id AS contract_id, contract.name AS contract_name, workitem_report.name, pay_before_last_month, trial_amount,
validate_amount, pay_before_last_month + validate_amount AS total_complete,  advance_rebate, buckle_retention, other_charged,
trial_amount - validate_amount AS hj_amount, (trial_amount - validate_amount)/trial_amount AS hj_rate, trial_date, validate_date,
workitem_report.memo
FROM workitem_report, workitem
LEFT JOIN contract ON contract.id = workitem.contract_id
WHERE workitem_report.workitem_id = workitem.id and contract.project_id = #{session[:pid]}
ORDER BY contract.contracttype, contract.id !
    render :text=>records_to_xml(contracts)
  end
  
  #支付汇总表
  def pay
    contracts = Contract.find_by_sql %!SELECT contract.contracttype, contract.id AS contract_id, contract.name AS contract_name, workitem_pay.name AS NAME, pay_before_last_month,
workitem_pay.pay_amount, pay_before_last_month + workitem_pay.pay_amount AS total_complete, pay_date, pay_reason, paytype, workitem_pay.memo
FROM workitem_pay, workitem
LEFT JOIN contract ON contract.id = workitem.contract_id
WHERE workitem_pay.workitem_id = workitem.id and contract.project_id = #{session[:pid]}
ORDER BY contract.contracttype, contract.id !
    render :text=>records_to_xml(contracts)
  end
  
  #结算汇总表
  def clearing
    contracts = Contract.find_by_sql %! SELECT workitem_clearing.name, contract.name AS contract_name, contract.id AS contract_id, contract.contracttype, trial_amount,workitem_clearing.clearing_amount,
trial_amount-workitem_clearing.clearing_amount AS hj_amount, (trial_amount-workitem_clearing.clearing_amount)/trial_amount AS hj_rate, 
trial_date, clearing_date, workitem_clearing.memo
FROM workitem_clearing, workitem
LEFT JOIN contract ON workitem.contract_id = contract.id 
WHERE workitem_clearing.workitem_id = workitem.id and contract.project_id = #{session[:pid]}
ORDER BY contract.contracttype, contract.id !
    render :text=>records_to_xml(contracts)
  end
end
