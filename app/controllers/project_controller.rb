require 'rexml/document'
class ProjectController < ApplicationController
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @projects = Project.paginate :page=>params[:page], :per_page => 20, :order=>"id"
  end

  def show
    @project = Project.find(session[:pid])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:notice] = '添加项目成功'
      redirect_to :controller=>"main", :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = '修改项目成功'
      redirect_to :action => 'show', :id=>@project
    else
      render :action => 'edit'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    flash[:notice] = '删除项目成功'
    redirect_to :action => 'list'
  end
  
  def participate
    @project = Project.find(params[:id])
  end
  
  def update_participate
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    flash[:notice] = '修改项目参与人成功'
    redirect_to :action => 'show', :id=>@project
  end
  
  def right
    @project = Project.find(session[:pid])
  end
  
  def update_right
    @project = Project.find(params[:id])
    ProjectRight.delete_all "project_id = #{@project.id}"
    
    params[:project].each{|userid, value|
      value.each{|right_type, right|
        ProjectRight.create(:project_id=>params[:id], :user_id=>userid, :right_type=>right_type, :right=>right)
      }
    }
    flash[:notice] = '修改项目权限成功'
    redirect_to :action => 'show', :id=>@project
  end
end 
