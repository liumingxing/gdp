class UserController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @users = User.paginate :page=>params[:page], :per_page => 10, :order=>"id"
  end
  
  def list_detail
    if !params[:id] || params[:id] == "-1"
      @users = User.paginate :page=>params[:page], :per_page => 20, :order=>"id"
    else
      @users = User.paginate :page=>params[:page], :per_page => 20, :order=>"id", :conditions=>"department_id=#{params[:id]}"
    end
    render :layout=>"notoolbar"
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.department_id = params[:department_id]
    render :layout=>"notoolbar"
  end

  def create
    @user = User.new(params[:user])
    @user.password = User.enc_password(@user.password.to_s)
    if @user.save
      flash[:notice] = '添加用户成功'
      redirect_to :action => 'list_detail', :id=>@user.department_id
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    render :layout=>"notoolbar"
  end

  def update
    @user = User.find(params[:id])
    old_pass = @user.password
    @user.update_attributes(params[:user])
    if old_pass != @user.password    #密码改变
      @user.password = User.enc_password(@user.password)
      @user.save
    end
    
    flash[:notice] = '修改账号信息成功'
    redirect_to :action => 'list_detail', :id=>@user.department_id
  end

  def destroy
    user = User.find(params[:id])
    department_id = user.department_id
    user.destroy
    redirect_to :action => 'list_detail', :id=>department_id
  end
end
