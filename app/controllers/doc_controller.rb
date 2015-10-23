class DocController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    conditions = []
    conditions << "project_id = #{session[:pid]}"
    conditions << "doc_type = '#{params[:t]}'"
    conditions << "contract_id = #{params[:contract_id]}" if params[:contract_id]
    @docs = Doc.paginate :page=>params[:page], :per_page => 10, :order=>"id desc", :conditions=>conditions.join(" and ")
  end

  def show
    @doc = Doc.find(params[:id])
  end

  def new
    @doc = Doc.new
  end

  def create
    @doc = Doc.new(params[:doc])
    @doc.project_id   = session[:pid]
    @doc.doc_type     = params[:t]
    @doc.user_id      = current_user.id
    @doc.contract_id  = params[:c]
    if @doc.save
      flash[:notice] = '上传资料成功.'
      redirect_to :action => 'list', :t=>params[:t], :c=>params[:c]
    else
      render :action => 'new'
    end
  end

  def edit
    @doc = Doc.find(params[:id])
  end

  def update
    @doc = Doc.find(params[:id])
    if @doc.update_attributes(params[:doc])
      flash[:notice] = 'Doc was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    doc = Doc.find(params[:id])
    doc.destroy
    redirect_to :action => 'list', :t=>doc.doc_type, :c=>doc.contract_id
  end
end
