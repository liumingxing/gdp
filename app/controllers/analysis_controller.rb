class AnalysisController < ApplicationController

  #获得估概预xml数据
  def get_data_ggy
    doc = REXML::Document.new("<Grid><Body><B></B></Body></Grid>")
    element = REXML::XPath.first(doc, "/Grid/Body/B")
    for root in ProjectTzgh.roots(session[:pid])
      root.insert_analysis_element(element)
    end
    str = ''
    doc.write(str)
    render :text => str
  end
  
  #合同分析
  def contract
    if !params[:id]
      @contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]} and iscontract = 1")
    else
      @contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]} and category_id = #{params[:id]} and iscontract = 1")
    end
  end
  
  #费用分析
  def feiyong
    if !params[:id]
      @contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]} and iscontract = 0")
    else
      @contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]} and category_id = #{params[:id]} and iscontract = 0")
    end
  end
  
  #动态分析
  def dynamic
    if !params[:id]
      @contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]}")
    else
      @contracts = Contract.find(:all, :conditions=>"project_id = #{session[:pid]} and category_id = #{params[:id]}")
    end
  end
  
  def fund_client
    if params[:id] && params[:id].size > 0
      @contracts = Contract.find(:all, :conditions=>"category_id = #{params[:id]}")
    else
      @contracts = Contract.find(:all)
    end
    if params[:dtype]
      @title = {"plan_amount"=>"资金计划明细", "audit_amount"=>"审定支付明细", "pay_amount"=>"实际支付明细"}[params[:dtype]]
    end
    render :layout=>"notoolbar"
  end
end
