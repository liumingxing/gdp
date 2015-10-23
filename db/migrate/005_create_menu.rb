class CreateMenu < ActiveRecord::Migration
  def self.up
    create_table :menu, :primary_key => :id do |t|
       t.column :menutype, :string, :limit=>100                   #业务菜单或系统菜单
       t.column :text, :string, :limit=>100
       t.column :url, :string, :limit=>100
       t.column :list_right, :integer
       t.column :edit_right, :integer
       t.column :parent_id,  :integer
       t.column :position,  :integer
       t.column :hide,  :integer
       t.column :blank, :integer        
       t.timestamps
    end
    
    root = Menu.create(:menutype=>"系统菜单", :text=>"所有功能")
    sys_manage = Menu.create(:parent_id=>root.id, :text=>"系统管理")
    
    Menu.create(:parent_id=>sys_manage.id, :text=>"系统配置", :url=>"/system_config")
    Menu.create(:parent_id=>sys_manage.id, :text=>"菜单管理", :url=>"/menu")
    Menu.create(:parent_id=>sys_manage.id, :text=>"部门管理", :url=>"/department")
    Menu.create(:parent_id=>sys_manage.id, :text=>"用户管理", :url=>"/user")
    Menu.create(:parent_id=>sys_manage.id, :text=>"公司管理", :url=>"/company")
    Menu.create(:parent_id=>sys_manage.id, :text=>"角色管理", :url=>"/role")
    Menu.create(:parent_id=>sys_manage.id, :text=>"权限管理", :url=>"/right")
    Menu.create(:parent_id=>sys_manage.id, :text=>"字典管理", :url=>"/dictionary")
    Menu.create(:parent_id=>sys_manage.id, :text=>"日志过滤器", :url=>"/logfilter")
    Menu.create(:parent_id=>sys_manage.id, :text=>"日志查看", :url=>"/log")
    Menu.create(:parent_id=>sys_manage.id, :text=>"电子表单管理", :url=>"/lmx_form")
    Menu.create(:parent_id=>sys_manage.id, :text=>"工作流管理", :url=>"/workflow_design")
    
    sys_manage = Menu.create(:parent_id=>root.id, :text=>"工作流")
    Menu.create(:parent_id=>sys_manage.id, :text=>"发起流程", :url=>"/workflow/start_flow")
    Menu.create(:parent_id=>sys_manage.id, :text=>"等待我审批流程", :url=>"/workflow/mywaiting_form")
    Menu.create(:parent_id=>sys_manage.id, :text=>"我发起的流程", :url=>"/workflow/myform_all")
    Menu.create(:parent_id=>sys_manage.id, :text=>"我审批过的流程", :url=>"/workflow/myprocessed_form")
    Menu.create(:parent_id=>sys_manage.id, :text=>"已结束的流程", :url=>"/workflow/myfinished_form_all")
    Menu.create(:parent_id=>sys_manage.id, :text=>"等待我阅知流程", :url=>"/workflow/mywaiting_yuezhi")
    
    sys_manage = Menu.create(:parent_id=>root.id, :text=>"业务管理")
    Menu.create(:parent_id=>sys_manage.id, :text=>"项目管理", :url=>"/project")
    Menu.create(:parent_id=>sys_manage.id, :text=>"单项工程结构全模板", :url=>"/pbs/template")
    Menu.create(:parent_id=>sys_manage.id, :text=>"单项工程", :url=>"/pbs/index")
    Menu.create(:parent_id=>sys_manage.id, :text=>"投资规划模板", :url=>'/tztemplate')
    Menu.create(:parent_id=>sys_manage.id, :text=>"合约规划模板", :url=>'/contract_template')
    
    root = Menu.create(:menutype=>"业务菜单", :text=>'"#{Project.find(session[:pid]).name}"')
    sub = Menu.create(:parent_id=>root.id, :text=>"基本信息")
    Menu.create(:parent_id=>sub.id, :text=>"项目信息", :url=>'/project/show')
    Menu.create(:parent_id=>sub.id, :text=>"项目权限", :url=>'/project/right')
    Menu.create(:parent_id=>sub.id, :text=>"项目资料", :url=>'/doc/list?t=project')
    
    sub = Menu.create(:parent_id=>root.id, :text=>"投资管控")
    Menu.create(:parent_id=>sub.id, :text=>"投资规划", :url=>'"/tzgh/index/#{session[:pid]}"')
    
    sub1 = Menu.create(:parent_id=>sub.id, :text=>"估算管理")
    Menu.create(:parent_id=>sub1.id, :text=>"估算书", :url=>'/budget/main?t=1')
    Menu.create(:parent_id=>sub1.id, :text=>"分配任务", :url=>'/budget/fprw?t=1')
    Menu.create(:parent_id=>sub1.id, :text=>"估算编制", :url=>'/budget/bz?t=1')
    Menu.create(:parent_id=>sub1.id, :text=>"估算审核", :url=>'/budget/sh?t=1')
    Menu.create(:parent_id=>sub1.id, :text=>"版本管理", :url=>'/budget/version?t=1')
    
    sub1 = Menu.create(:parent_id=>sub.id, :text=>"概算管理")
    Menu.create(:parent_id=>sub1.id, :text=>"概算书", :url=>'/budget/main?t=2')
    Menu.create(:parent_id=>sub1.id, :text=>"分配任务", :url=>'/budget/fprw?t=2')
    Menu.create(:parent_id=>sub1.id, :text=>"概算编制", :url=>'/budget/bz?t=2')
    Menu.create(:parent_id=>sub1.id, :text=>"概算审核", :url=>'/budget/sh?t=2')
    Menu.create(:parent_id=>sub1.id, :text=>"版本管理", :url=>'/budget/version?t=2')
    
    sub1 = Menu.create(:parent_id=>sub.id, :text=>"预算管理")
    Menu.create(:parent_id=>sub1.id, :text=>"预算书", :url=>'/budget/main?t=3')
    Menu.create(:parent_id=>sub1.id, :text=>"分配任务", :url=>'/budget/fprw?t=3')
    Menu.create(:parent_id=>sub1.id, :text=>"预算编制", :url=>'/budget/bz?t=3')
    Menu.create(:parent_id=>sub1.id, :text=>"预算审核", :url=>'/budget/sh?t=3')
    Menu.create(:parent_id=>sub1.id, :text=>"版本管理", :url=>'/budget/version?t=3')
    
    sub1 = Menu.create(:parent_id=>root.id, :text=>"合约管控")
    Menu.create(:parent_id=>sub1.id, :text=>"合约规划", :url=>'/hygh')
    Menu.create(:parent_id=>sub1.id, :text=>"合同管理", :url=>'/contract/list?t=1')
    Menu.create(:parent_id=>sub1.id, :text=>"费用管理", :url=>'/contract/list?t=2')
    sub1 = Menu.create(:parent_id=>root.id, :text=>"资金管理")
    Menu.create(:parent_id=>sub1.id, :text=>"资金计划", :url=>'/fund/plan')
    Menu.create(:parent_id=>sub1.id, :text=>"资金支付", :url=>'/fund/pay')
    
    sub = Menu.create(:parent_id=>root.id, :text=>"成本分析")
    Menu.create(:parent_id=>sub.id, :text=>"估概预分析", :url=>'/analysis/ggy')
    Menu.create(:parent_id=>sub.id, :text=>"合同分析", :url=>'/analysis/contract')
    Menu.create(:parent_id=>sub.id, :text=>"费用分析", :url=>'/analysis/feiyong')
    Menu.create(:parent_id=>sub.id, :text=>"资金分析", :url=>'/analysis/fund_client')
    Menu.create(:parent_id=>sub.id, :text=>"动态成本", :url=>'/analysis/dynamic')
    
    sub = Menu.create(:parent_id=>root.id, :text=>"报表输出")
    Menu.create(:parent_id=>sub.id, :text=>"合同汇总", :url=>'/report?t=contract')
    Menu.create(:parent_id=>sub.id, :text=>"变更汇总", :url=>'/report?t=change')
    Menu.create(:parent_id=>sub.id, :text=>"计量汇总", :url=>'/report?t=report')
    Menu.create(:parent_id=>sub.id, :text=>"支付汇总", :url=>'/report?t=pay')
    Menu.create(:parent_id=>sub.id, :text=>"结算汇总", :url=>'/report?t=clearing')
    
  end
  
  def self.down
    drop_table :menu
  end
end
