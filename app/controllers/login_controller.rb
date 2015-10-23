require 'digest/md5'
class LoginController < ApplicationController
  def index
    session[:user_id] = nil
    render :action=>'index', :layout=>false
  end
  
  #覆盖父类的login，取消登陆验证
  def check_user

  end
  
  def trylogin
    account = params[:account].strip
    password = params[:password]
    
    user = User.find_by_login(account)
    if !user
      flash[:notice] = "用户名不存在"
      write_log("登陆用户名#{account}不存在")
      redirect_to :action=>'index' 
      return
    end
    p password
    if !user.check_password(password)
      flash[:notice] = '密码错误'
      write_log("#{account}:登陆密码错误")
      redirect_to :action=>'index' 
    else
      user.last_login_time = Time.new
      user.save
      session[:user_id] = user.id
      flash[:notice] = '欢迎登陆:' + user.truename.to_s || user.login.to_s
      write_log("成功登陆系统")
      
      begin
        visit = SystemConfig.find_by_code("visitedtimes")
        visit.i += 1
        visit.save
      rescue
      
      end
      redirect_to :controller =>'main', :action=>'index' 
    end
  end
end
