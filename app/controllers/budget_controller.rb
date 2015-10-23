require 'rexml/document'
class BudgetController < ApplicationController
  before_filter :import_tree, :only=>%w(main fprw bz sh version)
  
  #检查是否有树形结构数据，没有则提醒导入
  def import_tree
    session[:old_path] = request.request_uri
    if ProjectBudget.count(:conditions=>"project_id=#{session[:pid]} and budgettype = '#{params[:t]}' and parent_id is null") == 0
      @tzghs = ProjectTzgh.find(:all, :conditions=>"project_id = #{session[:pid]}")
      render :action=>"import_tree"
      return false
    end
  end
  
  #导入初始树形结构
  def import_initial
    Project.find(session[:pid]).import_initial(params[:t], params[:checked_values].split(','))
    flash[:notice] = "导入成功"
    redirect_to session[:old_path]
  end
  
  #获得估概预算树xml数据
  #params[:t]从前端传来的时候不同浏览器不一样，有时候是utf8格式，有时候是gbk格式，所以要判断一下。
  def get_data
    @project = Project.find(session[:pid])
    t = params[:t]
    t = t.to_utf8 if !%w(估算 预算 概算).include?(t)
    render :text=>ProjectBudget.get_data("project_id = #{@project.id} and version_id =#{@project.current_version(t).id} and parent_id is null and budgettype='#{t}'")
  end
  
  #估概预风格xml，分配任务
  def style_fprw
    file = File.open("public/xml/gridstyle_fprw.xml", "r")
    doc = REXML::Document.new(file.read)
    file.close
    elements = REXML::XPath.match(doc, '/Grid/Cols/C')
    users = Project.find(session[:pid]).users
    elements[1].attributes["Enum"]      = "||#{users.collect{|u| u.name}.join('|')}"
    elements[1].attributes["EnumKeys"]  = "||#{users.collect{|u| u.id}.join('|')}"
    elements[2].attributes["Enum"]      = "||#{users.collect{|u| u.name}.join('|')}"
    elements[2].attributes["EnumKeys"]  = "||#{users.collect{|u| u.id}.join('|')}"
    str = ''
    doc.write(str)
    render :text=>str
  end
  
  #估概预风格xml，编制gridstyle_bz.xml
  def style_bz
    file = File.open("public/xml/#{params[:file]}", "r")
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
  
  
  #保存投资规划树形结构
  def upload_data
    render :text=>ProjectBudget.upload_data(params[:Data], :project_id => session[:pid])
  end
  
  def budget_unit
    @budget = ProjectBudget.find(params[:id].split("$").last)
    render :layout=>false
  end
  
  def add_unit
    @budget = ProjectBudget.find(params[:id])
    render :layout=>false
  end
  
  def edit_unit
    @unit = ProjectBudgetUnit.find(params[:id])
    @budget = @unit.budget
    render :layout=>false
  end
  
  def create_unit
    if !params[:unit][:name] || params[:unit][:name].size == 0
      redirect_to :action=>"budget_unit", :id=>params[:id]
      return
    end
    unit = ProjectBudgetUnit.new(params[:unit])
    unit.budget_item_id = params[:id]
    unit.save
    
    redirect_to :action=>"budget_unit", :id=>params[:id], :add=>'true'
  end
  
  def update_unit
    @unit = ProjectBudgetUnit.find(params[:id])
    @unit.update_attributes(params[:unit])
    redirect_to :action=>"budget_unit", :id=>@unit.budget_item_id, :add=>'true'
  end
  
  def delete_unit
    unit = ProjectBudgetUnit.find(params[:id])
    unit.destroy
    redirect_to :action=>"budget_unit", :id=>unit.budget_item_id, :add=>'true'
  end
  
  #插入分项指标
  def insert_fxzb
    if params[:jzlx]
      @dxlx = Pbs.find(:all, :conditions=>"pbstype = '#{params[:jzlx]}'")
    else
      @dxlx = []
    end
    
    if params[:ids] && params[:ids].size > 0
      ids = params[:ids].chop.split(",")
      for id in ids
        node = PbsNode.find(id)
        
        unit                    = ProjectBudgetUnit.new
        unit.budget_item_id     = params[:id]
        unit.name               = node.template.name
        unit.basis              = node.basis
        unit.unit               = node.unit
        unit.num                = 1
        unit.price              = node.price
        unit.feetype            = node.template.feetype
        unit.desc               = node.desc
        unit.save
      end
      
      render :text=>"<script>window.parent.close_dialog_and_refresh();</script>"
      return
    end
    
    render :layout=>"popup"
  end
  
  def version
    @versions = ProjectVersion.find(:all, :conditions=>"project_id = #{session[:pid]} and budgettype = '#{params[:t]}'")
  end
  
  def edit_version
    @version = ProjectVersion.find(params[:id])
  end
  
  def update_version
    @version        = ProjectVersion.find(params[:id])
    @version.update_attributes(params[:version])
    flash[:notice]  = "修改版本信息成功"
    redirect_to :action=>"version", :t=>@version.budgettype
  end
  
  #新开一个版本
  def new_version
    version            = ProjectVersion.new
    version.project_id = session[:pid]
    version.creator    = current_user.name
    version.budgettype = params[:t]
    version.text       = Time.new.to_s(:db)
    version.save
    
    project = Project.find(session[:pid])
    project.copy_to_version(version.id, params[:t])
    
    project.set_current_version(version.id, params[:t])
    flash[:notice]      = "新建版本成功"
    redirect_to :action=>"version", :t=>params[:t]
  end
  
  def set_current_version
    project = Project.find(session[:pid])
    project.set_current_version(params[:id], params[:t])
    flash[:notice]  = "设置当前版本成功"
    redirect_to :action=>"version", :t=>params[:t]
  end
  
  def pbs_attr
    budget_item = ProjectBudget.find(params[:id].split('$').last)
    @pbs = budget_item.pbs
    @property = Hash.new
    doc = REXML::Document.new(budget_item.properties || "<Property></Property>")
    for element in doc.root.elements
      @property[element.attributes["name"]] = element.attributes["value"]
    end
    render :layout=>"popup"
  end
  
  def save_pbs_attr
    doc = REXML::Document.new("<Property></Property>")
    root = doc.root
    params[:property].each{|key, value|
      element = root.add_element "p"
      element.attributes["name"] = key
      element.attributes["value"] = value
    }
    str = ''
    doc.write(str)
    budget = ProjectBudget.find(params[:id])
    budget.properties = str
    budget.save
    render :text=>"<script>window.parent.close_dialog();</script>"
  end
  
  def file_manager
    @budget = ProjectBudget.find(params[:id].split('$').last)
    render :layout=>"popup"
  end
  
  def upload_file
    file = BudgetFile.new(params[:file])
    file.budget_id = params[:budget_id]
    file.user_id = current_user.id
    file.save
    redirect_to :action=>"file_manager", :id=>params[:budget_id]
  end
  
  #版本比较
  def compare_version
    if !params[:version] || params[:version].size != 2
      flash[:notice] = "请选择2个版本以进行比较"
      redirect_to :action=>"version", :t=>params[:t]
    end
  end
  
  def get_data_version_compare
    version_ids = params[:v].split(',')
    doc = REXML::Document.new("<Grid><Body><B></B></Body></Grid>")
    element = REXML::XPath.first(doc, "/Grid/Body/B")
    for root in ProjectTzgh.roots(session[:pid])
      root.insert_version_compare_element(element, version_ids[0], version_ids[1], params[:t])
    end
    str = ''
    doc.write(str)
    render :text => str
  end
end
