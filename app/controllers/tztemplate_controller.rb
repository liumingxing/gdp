class TztemplateController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tztemplates = Tztemplate.paginate :page=>params[:page], :per_page => 10, :order=>"id desc"
  end

  def show
    @tztemplate = Tztemplate.find(params[:id])
  end

  def new
    @tztemplate = Tztemplate.new
  end

  def create
    @tztemplate = Tztemplate.new(params[:tztemplate])
    if @tztemplate.save
      flash[:notice] = 'Tztemplate was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tztemplate = Tztemplate.find(params[:id])
  end

  def update
    @tztemplate = Tztemplate.find(params[:id])
    if @tztemplate.update_attributes(params[:tztemplate])
      flash[:notice] = 'Tztemplate was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tztemplate.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  #获得树形
  def get_data
    render :text=>TztemplateNode.get_data("template_id = #{params[:id]} and (parent_id is null or parent_id = 0)")
  end
  
  #保存树形
  def upload_data
    render :text=>TztemplateNode.upload_data(params[:Data], :template_id=>params[:id])
  end
end
