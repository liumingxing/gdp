class RoleController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @roles = Role.paginate :page=>params[:page], :per_page => 10, :order=>"id"
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = '添加角色成功'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = '修改角色成功'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Role.find(params[:id]).destroy
    flash[:notice] = '删除角色成功'
    redirect_to :action => 'list'
  end
end
