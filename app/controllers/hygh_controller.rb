require 'rexml/document'

class HyghController < ApplicationController
  before_filter :check_hygh, :only=>"index"
  
  def check_hygh
    roots = Hygh.find(:all, :conditions=>"project_id = #{session[:pid]} and parent_id is null")
    if roots.size == 0
      redirect_to :action=>"import_tree"
      return false
    end
  end
  
  def get_style
    file = File.open("public/xml/gridstyle_hygh.xml", "r")
    doc = REXML::Document.new(file.read)
    file.close
    elements = REXML::XPath.match(doc, '/Grid/Cols/C')
    users = Project.find(session[:pid]).users
    elements[2].attributes["Enum"]      = "||#{users.collect{|u| u.name}.join('|')}"
    elements[2].attributes["EnumKeys"]  = "||#{users.collect{|u| u.id}.join('|')}"
    str = ''
    doc.write(str)
    render :text=>str
  end

  #获得投资规划数据
  def get_data
    render :text=>Hygh.get_data("project_id = #{session[:pid]} and parent_id is null")
  end
  
  #保存合约规划树形结构
  def upload_data
    render :text=>Hygh.upload_data(params[:Data], :project_id=>session[:pid])
  end
  
  def import_tree
    if params[:template]
      @hyghs = ContractTemplateNode.find(:all, :conditions=>"template_id = #{params[:template]}", :order=>"position")
    else
      @hyghs = []
    end
  end
  
  def import_initial
    Hygh.import_initial(session[:pid], params[:checked_values].split(","))
    flash[:notice] = "导入数据成功"
    redirect_to :action=>"index"
  end
  
  def hygh_unit
    @hygh = Hygh.find_by_id(params[:id].split("$").last)
    if @hygh.children.size > 0
      render :text=>"请选择叶节点"
    else
      @units = HyghUnit.find(:all, :conditions=>"hygh_id = #{@hygh.id}")
      render :layout=>false
    end
  end
  
  #插入预算项
  def insert_budget_dlg
    render :layout=>"popup"
  end
  
  def insert_budget
    @hygh = Hygh.find(params[:id])
    for id in params[:ids].chop.split(",")
      budget = ProjectBudget.find(id.split('$').last)
      unit           = HyghUnit.new
      unit.hygh_id   = params[:id]
      unit.budget_id = budget.id
      unit.name      = budget.name
      unit.cost      = budget.jzgcf.to_f + budget.sbgzf.to_f + budget.azgcf.to_f + budget.qtfy.to_f
      unit.save
    end
    
    render :text=>"<script>window.parent.close_dialog_and_refresh();</script>"
  end
end
