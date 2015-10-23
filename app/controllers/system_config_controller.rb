class SystemConfigController < ApplicationController
  def index
    @config = SystemConfig.find(:all, :limit=>1)[0]
    @config = SystemConfig.new if !@config
  end
  
  def update
    @config = SystemConfig.find(:all, :limit=>1)[0]
    if @config.update_attributes(params[:config])
      flash[:notice] = '修改系统配置成功'
      redirect_to :action => 'index'
    else
      render :action => 'index'
    end
  end
  
  def delete
    @config = SystemConfig.find(:all, :limit=>1)[0]
    @config.logo = nil
    @config.save
    render :action => 'index'
  end
  
  def reboot
    $REBOOT = true
    render :text=>"成功重启，请20秒后访问"
  end
  
  def clear_session
    count = 0
    yesterday = Time.new.yesterday
    dir = Dir.open("tmp/sessions")
    begin
      dir.each { |path|
        next if ['.', '..'].include?(path)
        path = "tmp/sessions/" + path
        if File.ctime(path) < yesterday
          count += 1
          File.delete(path)
        end
      }
    ensure
      dir.close
    end

    flash[:notice] = "删除文件#{count}个"
    render :action => 'index'
  end
end
