class LogController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
   @ytwg_eventlogs = Log.paginate :page=>params[:page], :per_page => 20, :order => params[:order]||"id desc" 
  end

  def show
    @ytwg_eventlog = Log.find(params[:id])
  end

  def new
    @ytwg_eventlog = Log.new
  end

  def create
    @ytwg_eventlog = Log.new(params[:ytwg_eventlog])
    if @ytwg_eventlog.save
      flash[:notice] = 'YtwgEventlog was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @ytwg_eventlog = Log.find(params[:id])
  end

  def update
    @ytwg_eventlog = Log.find(params[:id])
    if @ytwg_eventlog.update_attributes(params[:ytwg_eventlog])
      flash[:notice] = 'YtwgEventlog was successfully updated.'
      redirect_to :action => 'show', :id => @ytwg_eventlog
    else
      render :action => 'edit'
    end
  end

  def destroy
    YtwgEventlog.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
