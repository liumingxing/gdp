class RightController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rights = Right.paginate :page=>params[:page], :per_page => 20, :order=>"position, id"
  end

  def show
    @right = Right.find(params[:id])
  end

  def new
    @right = Right.new
  end

  def create
    @right = Right.new(params[:right])
    if @right.save
      flash[:notice] = '添加权限成功'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @right = Right.find(params[:id])
  end

  def update
    @right = Right.find(params[:id])
    if @right.update_attributes(params[:right])
      flash[:notice] = '修改权限成功'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Right.find(params[:id]).destroy
    flash[:notice] = '删除权限成功'
    redirect_to :action => 'list'
  end
end
