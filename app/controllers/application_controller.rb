# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
include ActionView::Helpers::NumberHelper
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  skip_before_filter :verify_authenticity_token  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  
  helper_method  :current_user
  helper_method  :checkright

  before_filter :check_user
  before_filter :check_url_right
  before_filter :add_log
  before_filter :anti_inject

  before_filter :check_url_right
  def check_url_right
    if !$Filter
      $Filter = {}
      for menu in Menu.find(:all)
        $Filter[menu.url] = menu.list_right
      end
    end
    
    if $Filter[request.env["REQUEST_URI"]] && $Filter[request.env["REQUEST_URI"]] > 0
      if !current_user.rights.collect{|r| r.id}.include?($Filter[request.env["REQUEST_URI"]])
        flash[:notice] = "对不起，您越权访问了网页！"
        redirect_to :controller=>"login", :action=>"index"
        return false
      end
    end
    
    return true
  end

  def check_user
    if !current_user
      redirect_to :controller=>"login", :action=>"index"
      flash[:notice] = "请先登录"
    end
  end
  
  #根据id来校验是否拥有权限
  def checkright_by_id(right_id)
    current_user.rights.collect{|r| r.id}.include?(right_id)
  end
  
  def checkright(right)
    return false if !current_user
    
    #对管理员返回真
    return true if current_user.login == 'admin'
    
    moduleright = Right.find_by_name(right)
    #没有此权限则对所有用户返回真
    return true if !moduleright
    
    for role in current_user.roles
      return true if role.right_ids.include?(moduleright.id)
    end
    
    return false
  end
  
  #将active-record集合转换为grid++需要的xml数据源格式
  def records_to_xml(records)
    result = '<?xml version="1.0" encoding="UTF-8"?><xml>'
    for record in records
      result += "<row "
      record.attributes.each{|key, value|
        p value.class
        if value.class == Time
          result += "#{key} = '#{value.to_formatted_s(:db)}' "
        else
          result += "#{key} = '#{value}' "
        end
      }
      result += "/>"
    end
    result += '</xml>'
    result
  end
  
  def anti_inject
    for value in params.values
      next if !value || value.class != String
      v = value.dup.downcase
      if v =~/select.+from/ || value=~/drop / || value=~/delete.+from/ || value=~/update.+set/|| value=~/<script/  
        render :text=>"发现您的请求可能存在危险操作，无法继续！我们已经记录下您的IP，以备调查。"
        return false
      end
    end
  end

  #添加日志
  def add_log
    if $FilterMap[request.path]
      log = Log.new
      log.time_occured = Time.new
      log.username = "#{current_user.name}  #{current_user.truename}"  if current_user
      log.description = $FilterMap[request.path]
      log.url = request.path
      log.ip = request.remote_ip
      log.save
    end
    true
  end
  
  def add_log_desc(desc)
      log = Log.new
      log.time_occured = Time.new
      log.username = "#{current_user.name}  #{current_user.truename}"  if current_user
      log.description = desc
      log.url = request.path
      log.ip = request.remote_ip
      log.save
  end

  def current_user
    @current_user = @current_user || User.find_by_id(session[:user_id])
  end


  def read_data_from_xml(params_xml)
    param_doc = REXML::Document.new(params_xml)
    new_doc = REXML::Document.new('<?xml version="1.0" encoding="utf-8" ?><root></root>')
    for element in param_doc.root.elements
      next if element.attributes["show"] == "4"
      if element.attributes["type"] == "下拉型"
        node = new_doc.root.add_element "param"
        node.attributes["name"] = element.attributes["name"]
        element.each_element{|select|
          s_node = node.add_element "select"
          s_node.attributes["name"] = select.attributes["name"]
          s_node.attributes["value"] = params["#{element.attributes['name']}"]["#{select.attributes['name']}"]
        }
      else
        node = new_doc.root.add_element "param"
        node.attributes["name"] = element.attributes["name"]
        node.attributes["value"] = params["#{element.attributes['name']}"]
      end
    end
    str = ""
    new_doc.write(str, 2)
    return str
  end


  def rescue_action_in_public(exception)  
     render :partial => "share/error", :layout=>"error", :locals=>{:exception=>exception}
  end  

  #针对单表
  def to_single_pretty(controllername, editable=true, tablename=nil)
    tablename = controllername if !tablename
    funcs = YtwgFunction.find(:all, :conditions=>"controller_name = '#{controllername}'")
    if editable
      action = 'single_pretty_edit'
    else 
      action = 'single_pretty_show'
    end
    if funcs.size > 0
      if funcs[0].template && funcs[0].template.size > 0
        redirect_to :controller=>'main', :action=>action, :tablename=>tablename, :id=>params[:id], :function_id=> funcs[0].id
      end
    end
  end

  #针对主从表
  def to_double_pretty(controllername, args)
    tablename = args[:primary_tablename]||controllername
    editable  = args[:editable]
    float_tablename =args[:float_tablename]
    float_keyname   = args[:float_keyname]||'id'
    float_foreignkeyname = args[:float_foreignkeyname]||"#{tablename}_id"

    funcs = YtwgFunction.find(:all, :conditions=>"controller_name = '#{controllername}'")
    if editable
      action = 'double_pretty_edit'
    else 
      action = 'double_pretty_show'
    end
    if funcs.size > 0
      if funcs[0].template && funcs[0].template.size > 0
        redirect_to :controller=>'main', :action=>action, :tablename=>tablename, :id=>params[:id], 
          :function_id=> funcs[0].id, :float_tablename=>float_tablename, :float_keyname=>float_keyname,
          :float_foreignkeyname => float_foreignkeyname
      end
    end
  end

  #为CTable填充值
  def set_table_data(table, record)
    for field in record.attribute_names
      rowcol = table.GetCellByFieldName(field)
      next if rowcol[0] == -1
      value = record[field]
      value = value.strftime("%Y-%m-%d") if value.kind_of?(Time)
      if value.kind_of?(TrueClass) || value.kind_of?(FalseClass)
        value = '1' if value.kind_of?(TrueClass)
        value = '0' if value.kind_of?(FalseClass)
      end
      table.SetCellValue(rowcol[0], rowcol[1], EncodeUtil.change("GB2312", "UTF-8", value.to_s))
    end
  end  

  protected

  def current_user
    @session_login_user ||= User.find_by_id(session[:user_id])
  end

  private

  def write_log(text)
    log = Log.new
    log.username = current_user.name if current_user
    log.description = text
    log.ip = request.remote_ip
    log.url = request.path
    log.save
  end

  def SetTableData(table, record)
    for field in record.attribute_names
      rowcol = table.GetCellByFieldName(field)
      next if rowcol[0] == -1
      value = record[field].to_s
      value = record[field].strftime("%Y-%m-%d") if record[field].class==Time 
      table.SetCellValue(rowcol[0], rowcol[1], EncodeUtil.change("GB2312", "UTF-8", value))
    end
  end 
 
end
