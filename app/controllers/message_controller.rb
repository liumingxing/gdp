class MessageController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @messages = Message.paginate :page=>params[:page], :per_page => 20, :order=>"id desc", :conditions=>"user_id = #{session[:user_id]}"
  end

  def show
    @message = Message.find(params[:id])
    @message.isread = 1
    @message.save
  end

  def new
    @message = Message.new
  end

  def create
    for user_id in params[:user_ids].split(",")
      message = Message.new(params[:message])
      message.sender = current_user.name
      message.user_id = user_id
      message.save
    end

    flash[:notice] = '发送消息成功.'
    redirect_to :action => 'list'
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      flash[:notice] = 'Message was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Message.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
