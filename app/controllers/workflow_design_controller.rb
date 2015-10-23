require 'rexml/document'
require 'gtable'
require "workflow/FlowProcess"
require "workflow/FlowMeta"
class WorkflowDesignController < ApplicationController
  before_filter :get_doc, :only=>%w(add_state add_child set_position add_line get_state_property set_state_property get_line_property set_line_property delete_state delete_line listinterface uploadinterface)
  after_filter  :save_doc, :only=>%w(add_state add_child set_position add_line set_state_property set_line_property delete_state delete_line)
  
  def get_doc
    @workflow = Workflow.find(params[:id])
    @doc      = REXML::Document.new(@workflow.content)
  end
  
  def save_doc
    str = ''
    @doc.write(str, 2)
    @workflow.content = str
    @workflow.save
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @workflows = Workflow.paginate :page=>params[:page], :per_page => 20
  end

  def show
    @workflow = Workflow.find(params[:id])
  end

  def new
    @workflow = Workflow.new
  end

  def create
    @workflow = Workflow.new(params[:workflow])
    if @workflow.save
      flash[:notice] = '新建工作流成功'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @workflow = Workflow.find(params[:id])
  end

  def update
    @workflow = Workflow.find(params[:id])
    if @workflow.update_attributes(params[:workflow])
      flash[:notice] = 'Workflow was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Workflow.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def design
    @workflow = Workflow.find(params[:id])
    if @workflow.content
      @doc   = REXML::Document.new(@workflow.content)
    else  
      @doc   = REXML::Document.new('<?xml version="1.0" encoding="UTF-8"?><workflow><start name="开始" limit_type="right" select_next="0" limit="" enter="" leave="" left="20" top="200" width="50" height="50" /><end name="结束" limit_type="right" limit="" select_next="0" enter="" leave="" left="400" top="200" width="50" height="50" /></workflow>')
      str = ''
      @doc.write(str, 2)
      @workflow.content = str
      @workflow.save
    end
    
    @element = REXML::XPath.first(@doc, "/workflow/start")
    render :layout=>false
  end
  
  #添加状态
  def add_state
    @doc.root.add_element "state", {"name" => params[:name], "limit_type"=>"right", "limit"=>"", "left"=>params[:left], "top"=>params[:top], "width"=>80, "height"=>50}
    render :text=>"添加状态成功"
  end
  
  #添加子流程
  def add_child
    @doc.root.add_element "children", {"name" => params[:name], "left"=>params[:left], "top"=>params[:top], "width"=>80, "height"=>50}
    render :text=>"添加状态成功"
  end
  
  #设置rect的位置
  def set_position
    element = get_state_by_name(@doc, params[:name])
    if element
      element.attributes["left"] = params[:left]
      element.attributes["top"]  = params[:top]
    end
    render :text=>"改变节点位置成功"
  end
  
  #添加线条
  def add_line
    @doc.root.add_element "trasit", {"condition"=>"", "from"=>params[:from], "to"=>params[:to]}
    render :text=>"添加流转成功"
  end
  
  #获得状态的属性
  def get_state_property
    @element = get_state_by_name(@doc, params[:name])
    p @element
    render :partial=>"state_property", :locals=>{:alert=>params[:alert], :notice=>params[:notice], :script=>params[:script]}
  end
  
  #设置状态的属性
  def set_state_property
    params[:name] = params[:oldname] if !params[:name]
    if params[:name] != params[:oldname]                #名称改变了
      if get_state_by_name(@doc, params[:name])       #重名 
        redirect_to :action=>"get_state_property", :id=>params[:id], :name=>params[:oldname], :alert=>"对不起，名称重复"
        return
      else                                              #流转需要重命名
        for line in REXML::XPath.match(@doc, "/workflow/trasit") 
          puts line.attributes["from"]
          
          line.attributes["from"] = params[:name] if line.attributes["from"] == params[:oldname] 
          line.attributes["to"] = params[:name] if line.attributes["to"] == params[:oldname] 
        end
      end
    end
    
    element = get_state_by_name(@doc, params[:oldname])
    element.attributes["name"]        = params[:name]
    element.attributes["limit_type"]  = params[:limit_type]
    element.attributes["limit"]       = params[:limit]
    element.attributes["select_next"] = params[:select_next]
    element.attributes["same_department"] = params[:same_department]
    element.attributes["huiqian"]     = params[:huiqian]
    element.attributes["enter"]       = params[:enter]
    element.attributes["leave"]       = params[:leave]
    
    script = ''
    script = "window.location.reload(true);" if params[:name] != params[:oldname]
    redirect_to :action=>"get_state_property", :id=>params[:id], :name=>params[:name], :notice=>"更新状态属性成功", :script=>script
  end
  
  def get_line_property
    @element = get_line_by_name(@doc, params[:from], params[:to])
    render :partial=>"line_property", :locals=>{:notice=>params[:notice]}
  end
  
  def set_line_property
    element = get_line_by_name(@doc, params[:from], params[:to])
    element.attributes["condition"] = params[:condition]
    redirect_to :action=>"get_line_property", :id=>params[:id], :from=>params[:from], :to=>params[:to], :notice=>"更新流转属性成功"
  end
  
  def delete_state
    element = get_state_by_name(@doc, params[:name])
    @doc.root.delete(element)
    
    for line in REXML::XPath.match(@doc, "/workflow/trasit[@from='#{params[:name]}']") + REXML::XPath.match(@doc, "/workflow/trasit[@to='#{params[:name]}']")
      @doc.root.delete(element)
    end
    
    redirect_to :action=>"design", :id=>params[:id]
  end
  
  def delete_line
    for line in REXML::XPath.match(@doc, "/workflow/trasit[@from='#{params[:from]}']")
      if line.attributes["to"] == params[:to]
        @doc.root.delete(line) 
      end
    end
    redirect_to :action=>"design", :id=>params[:id]
  end
  
#####################################################
  def listinterface
    @states = REXML::XPath.match(@doc, "/workflow/start") + REXML::XPath.match(@doc, "/workflow/state") + REXML::XPath.match(@doc, "/workflow/end")
  end    
  
  #上传状态节点的录入界面
  def uploadinterface
    if params[:name]  #指定状态名称
      form = WorkflowInterface.find(:first, :conditions=>"flow_id = #{params[:id]} and state_name = '#{params[:name]}'")
      if !form
        form              = WorkflowInterface.new
        form.flow_id      = params[:id]
        form.state_name   = params[:name]
      end
      form.form_id = params[:form]
      form.save
    else              #不指定状态名称
      flow = Workflow.find(params[:id])
      for state in REXML::XPath.match(@doc, "/workflow/start") + REXML::XPath.match(@doc, "/workflow/state") + REXML::XPath.match(@doc, "/workflow/end")
        form = WorkflowInterface.find(:first, :conditions=>"flow_id = #{params[:id]} and state_name = '#{state.name}'")
        if !form
          form            = WorkflowInterface.new
          form.flow_id    = params[:id]
          form.state_name = state.attributes["name"]
        end
        form.form_id = params[:form]
        form.save
      end
    end
    flash[:notice] = "设置状态界面成功"
    redirect_to :action=>"listinterface", :id=>params[:id]
  end
  
  #生成关联表
  def upload_formtable
    @workflow = Workflow.find(params[:id])
    @lmx_form = LmxForm.find(params[:form])
    conn = ActiveRecord::Base.connection
    conn.create_table "workflow_#{@lmx_form.code.downcase}", :primary_key=>:id do |t|
      t.column "user_id", :integer                                                #流程发起人的id
      t.column "flow_id", :integer      
      t.column "next_user_ids", :string, :limit=>200                              #工作流id
      t.column "_content", :text                                                  #审批用正文域
      t.column "_state", :string, :limit=>30
      @table = GTable.new(@lmx_form.text)
      
      @table.input_cells{|cell, row_index, col_index|
        name = cell.attributes["name"]
        name = ('A'[0]+col_index-1).chr + row_index.to_s if !name || name.size == 0
        
        case cell.attributes["type"]
        when nil
          t.column name, :integer
        when "integer"
          t.column name, :integer
        when "float"
          t.column name, :decimal, :precision => 15, :scale => 3 
        when "text"
          t.column name, :string, :limit=>255
        when "date"
          t.column name, :date
        when "datetime"
          t.column name, :datetime
        when "textarea"
          t.column name, :text
        when "select"
          t.column name, :text, :limit=>100
        when "check"
          t.column name, :boolean
        end
      }
      t.timestamps
    end
    @workflow.formtable_id = params[:form]
    @workflow.save
    flash[:notice] = "生成关联表成功"
    redirect_to :action=>"listinterface", :id=>params[:id]
  end
  
  #删除关联表
  def delete_formtable
    @workflow = Workflow.find(params[:id])
    conn = ActiveRecord::Base.connection
    conn.drop_table("workflow_"+@workflow.formtable.code.downcase)
    @workflow.formtable = nil
    @workflow.save
    flash[:notice] = "删除表定义成功"
    redirect_to :action=>"listinterface", :id=>params[:id]
  end
  
  #上传xml文件
  def upload
    if !params[:file] || params[:file].size == 0
      flash[:notice] = "请选择正确的文件"
      redirect_to :action=>"list"
      return
    end
    xml = params[:file].read
    @workflow = Workflow.new()
    @workflow.content = xml
    @workflow.name = "未命名"
    @workflow.save
    
    redirect_to :action=>"list"
  end
  
  #下载表单xml文件
  def download
    @workflow = Workflow.find(params[:id])
    send_data @workflow.content, :filename=> "#{@workflow.name}.xml".to_gb2312
  end
  
  def limit
    render :layout=>false
  end
  
  
private
  def get_state_by_name(doc, name)
    return REXML::XPath.first(doc, "/workflow/start") if name == "开始"
    return REXML::XPath.first(doc, "/workflow/end") if name== "结束"
    element = REXML::XPath.first(doc, "/workflow/state[@name='#{name}']") 
    if element 
      return element
    else
      return REXML::XPath.first(doc, "/workflow/children[@name='#{name}']") 
    end
  end  

  def get_line_by_name(doc, from, to)
    for line in REXML::XPath.match(doc, "/workflow/trasit[@from='#{from}']")
      return line if line.attributes["to"] == to
    end
    return nil
  end
end
