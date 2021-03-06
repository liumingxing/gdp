class CompanyController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @companies = Company.paginate :page=>params[:page], :per_page => 20
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:notice] = '创建公司成功'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash[:notice] = '更新公司信息成功'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
