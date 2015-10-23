require 'rexml/document'

class TzghController < ApplicationController
  #获得投资规划数据
  def get_data
    render :text=>ProjectTzgh.get_data("project_id = #{session[:pid]} and parent_id is null")
  end
  
  #上传树形结构
  def upload_data
    render :text=>ProjectTzgh.upload_data(params[:Data], :project_id=>session[:pid])
  end
  
  def select_template
    if params[:id]
      @tztemplate = Tztemplate.find(params[:id])
    else
      @tztemplate = Tztemplate.new
    end
    render :layout=>false
  end
  
  #导入模板
  def import_template
    for id in params[:checked_values].split(",")
      next if id.to_i == 0
      t = ProjectTzgh.find(:first, :conditions=>"project_id=#{session[:pid]} and template_node_id = #{id}")
      next if t
      
      node               = TztemplateNode.find(id)
      t                  = ProjectTzgh.new
      t.project_id       = session[:pid]
      t.name             = node.name
      t.template_node_id = node.id
      t.feetype          = node.feetype
      t.feescope         = node.desc
      t.position         = node.position
      if node.parent
        pt = ProjectTzgh.find(:first, :conditions=>"project_id = #{session[:pid]} and template_node_id=#{node.parent.id}")
        t.parent_id      = pt.id if pt
      end
      t.save
    end
    redirect_to :action=>"index"
  end
  
  #新建单项工程
  def select_pbs
    if params[:pbstype]
      @pbses = Pbs.find(:all, :conditions=>"pbstype='#{params[:pbstype]}'")
    else
      @pbses = []
    end
    
    if params[:pbs] && params[:pbs].size > 0
      @pbs = Pbs.find(params[:pbs])
    end
    render :layout=>false
  end
  
  #导入单项工程
  def import_pbs
    tzgh            = ProjectTzgh.new
    tzgh.project_id = session[:pid]
    tzgh.pbs_id     = params[:pbs]
    tzgh.name       = params[:name]
    tzgh.feetype    = "工程费用"
    tzgh.parent_id  = params[:id].split('$').last
    tzgh.save
    
    for id in params[:checked_values].split(",")
      next if id.to_i == 0
      
      node               = PbsTemplate.find(id)
      t                  = ProjectTzgh.new
      t.project_id       = session[:pid]
      t.pbs_id           = params[:pbs]
      t.pbs_node_id      = node.id
      t.name             = node.name
      t.feetype          = node.feetype
      t.feescope         = node.feescope
      t.position         = node.position
      if !node.parent
        t.parent_id      = tzgh.id
      else
        pt = ProjectTzgh.find(:first, :conditions=>"project_id = #{session[:pid]} and pbs_node_id = #{node.parent.id}", :order=>"id desc")
        t.parent_id = pt.id if pt
      end
      t.save
    end
    
    redirect_to :action=>"index"
  end
  
end
