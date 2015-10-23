require 'rexml/document'
require 'gtable'
require "workflow/FlowProcess"
require "workflow/FlowMeta"
class WorkflowController < ApplicationController
##############################################################################
  def start_flow
    @flows = Workflow.paginate :page=>params[:page], :per_page=>20, :conditions=>"ischild <> 1 or ischild is null"
    for flow in @flows
      x_flow = FlowMeta::LoadWorkFlow(flow.name, flow.content)
      @flows.delete(flow) if !check_state_right(x_flow, "开始")
    end
  end  
  
  def write_form
    @flow = Workflow.find(params[:flowid])
    flow = FlowMeta::LoadWorkFlow(@flow.name, @flow.content)
  end
  
  def write_form
    @flow = Workflow.find(params[:flowid])
    Anon.set_table_name("workflow_" + @flow.formtable.code.downcase)
    Anon.reset_column_information() 

    if params[:formid]                                          #写已有表单
      form_record = Anon.find(params[:formid])
      state_name = form_record._state         
    else                                                        #新建立表单
      form_record = Anon.new
      form_record._state = '开始'
      state_name = form_record._state                           #当前状态名称

      if params[:users]
        form_record.user_id = current_user.id
        form_record.flow_id = params[:flowid]
        form_record.save
        params[:formid] = form_record.id
        params[:users].each { |state, user|
          select = WorkflowSelect.new
          select.user_id = user
          select.flow_id = params[:flowid]
          select.form_id = form_record.id
          select.state   = state
          select.save
        }
      end
    end
    
    if @flow.flow_type == "固定流"
      flow = FlowMeta::LoadWorkFlow(@flow.name, @flow.content)
      flow.expand_all                                           #展开子流程

      if !params[:formid]                                       #检查是否需要先期选人
        @select_user_states = []
        for state in flow.states
          if state.limit_type == "select_user"
            @select_user_states << state
          end
        end
        
        if @select_user_states.size > 0
          render :action=>"select_user"
          return
        end
      end
  
      if form_record._state =~ /\(.+\)/       #会签状态
        form_record._state.gsub!(/\(.+\)/, '')
      end
  
      states = []
      for state in form_record._state.split(',')
        states << state if check_state_right(flow, state)
      end
      
      if states.size > 0
        state_name = states[0]
      else
        state_name = '开始'
      end
      process = FlowProcess.new(flow, form_record, state_name)
      process.user = current_user
      process.signal_enter
      
      @state_name = state_name
      @state = flow.get_state(@state_name)
      
      if !state_name.index('-')   #子流程界面
        interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{@flow.id} and state_name = '#{state_name}'")
      else
        v = state_name.split('-')
        f = YtwgWorkflow.find_by_name(v[0])
        interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{f.id} and state_name = '#{v[1]}'")
      end
      interface_xml = interface.form.text
    elsif @flow.flow_type == "任意流"
      if form_record._state == "开始"
        flow = FlowMeta::LoadWorkFlow(@flow.name, @flow.content)
        process = FlowProcess.new(flow, form_record, "开始")
        process.user = current_user
        process.signal_enter
      end
      
      interface_xml = @flow.formtable.text
    end
    
    form = GTable.new(interface_xml)
    @style = form.to_s(:style)
    if !params[:formid]         #执行初始化事件
      @form = form_record
      instance_eval(form.get_script(:init))
    end
    @html  = form.to_s(:edit, form_record)
    @historys = WorkflowHistory.find(:all, :conditions=>"flow_id=#{params[:flowid]} and form_id = #{params[:formid]}") if params[:formid]
    
    instance_eval("@#{@flow.formtable.code.downcase} = form_record")
  end
  
  def update_form
    @flow = Workflow.find(params[:id])
    Anon.set_table_name("workflow_" + @flow.formtable.code.downcase)
    Anon.reset_column_information() 
    
    if @flow.flow_type == "固定流"
      flow = FlowMeta::LoadWorkFlow(@flow.name, @flow.content)
      flow.expand_all                     #展开子流程
  
      if params[:formid] && params[:formid].size > 0        #已有表单
        form = Anon.find(params[:formid])
        if form._state.index("-")    #在子流程状态
          child_flow_name = form._state[0, form._state.index('-')]
          state_name      = form._state[form._state.index('-')+1..form._state.size].gsub(/\(.+\)/, '')
          table_name      = get_table_name(child_flow_name, state_name)
          form.update_attributes(params[table_name])
        end
        
        form.update_attributes(params[@flow.formtable.code])  
        
        states = []
        for state in form._state.split(',')
          states << state  if check_state_right(flow, state.gsub(/\(.+\)/, ''))
        end
        
        state_name = states[0]
      else                                                    #新建表单
        form = Anon.new(params[@flow.formtable.code.downcase])
        form._state = '开始'
        state_name = form._state
        form.user_id = current_user.id
        form.flow_id = @flow.id
      end
      
      if params[:back] == "1"   #打回到以前的步骤
        #处理完后直接跳回本状态
        if params[:back_method] == "1"
          back = WorkflowFormback.new
          back.flow_id = @flow.id
          back.form_id = form.id
          back.state  = form._state
          back.user   = current_user.name
          back.save
        end
        
        form._state = params[:back_step]
        form.save
      else
        formback = WorkflowFormback.find(:first, :conditions=>"flow_id=#{@flow.id} and form_id='#{params[:formid]}'")
        if !formback    #上步没有打回操作
          process = FlowProcess.new(flow, form, state_name)
          process.user = current_user
          process.signal_leave(params[:next_step], params[:jbr].to_s.gsub(",", "_"))
        else            #上步有打回操作
          form._state = formback.state
          form.save
          formback.destroy
        end
      end
    elsif @flow.flow_type == "任意流"
      if params[:formid] && params[:formid].size > 0        #已有表单
        form = Anon.find(params[:formid])
        form.update_attributes(params[@flow.formtable])  
      else
        form = Anon.new(params[@flow.formtable.code.downcase])
        form.user_id = current_user.id
        form.flow_id = @flow.id
      end
      form.next_user_ids = params[:next_user_ids]
      if form.next_user_ids.to_s.size > 0
        form._state = '未结束'
      else
        form._state = '结束'
      end
      form.save
      state_name = form._state
    end
    
    if form._state == "结束"
        flow = FlowMeta::LoadWorkFlow(@flow.name, @flow.content) if !flow
        process = FlowProcess.new(flow, form, "结束")
        process.user = current_user
        process.signal_enter
        form.save
    end
    
    
    #处理上传附件
    1.upto(100) do |i|
      if params["attach#{i}"] && params["attach#{i}"][:path] && params["attach#{i}"][:path] != ""
        file = WorkflowFile.new(params["attach#{i}"])
        file.flow_id   = @flow.id
        file.form_id   = form.id
        file.uploader  = current_user.name
        file.save
      else
        break
      end
    end
    
    #保存处理历史
    history = WorkflowHistory.new
    history.user_id = current_user.id
    history.flow_id = @flow.id
    history.form_id = form.id
    history.process_time = Time.new
    history.memo = params[:memo]
    history.state_name = state_name
    history.point = params[:point]
    history.save
    
    #处理阅知
    if !params[:yuezhi_ids].blank?
      params[:yuezhi_ids].split(",").each do |user_id|
        yuezhi = WorkflowYuezhi.new
        yuezhi.flow_id = @flow.id
        yuezhi.form_id = form.id
        yuezhi.user_id = user_id
        yuezhi.state = state_name
        yuezhi.users = params[:yuezhi_names]
        yuezhi.creator = current_user.name
        yuezhi.save
      end
    end

    if params[:formid]        #已有表单
      redirect_to :action=>'mywaiting_form'   #转向等待处理的表单页面
    else
      redirect_to :action=>'myform_all'           #转向我的表单页面
    end
  end
  
  #等待我处理的所有流程
  def mywaiting_form
    @workflows = Workflow.find(:all, :conditions=>"ischild <> 1 or ischild is null")
    @forms = Array.new
    for flow in @workflows
      next if !flow.formtable                 #没上传表单
      
      if flow.flow_type == "固定流"
        @forms += get_wait_form(flow.id)
      elsif flow.flow_type == "任意流"
        Anon.set_table_name("workflow_" + flow.formtable.code.downcase)
        Anon.reset_column_information() 
        @forms += Anon.find(:all, :conditions=>"next_user_ids = '#{current_user.id}' or next_user_ids like '#{current_user.id},%' or next_user_ids like '%,#{current_user.id}' or next_user_ids like '%,#{current_user.id},%'")
      end
    end
    @forms.sort!{|a, b| b.created_at <=> a.created_at}
  end
  
  #我建立的所有流程
  def myform_all
    @forms = []
    for flow in Workflow.find(:all, :conditions=>"ischild <> 1 or ischild is null")
      next if !flow.formtable
      Anon.set_table_name("workflow_" + flow.formtable.code.downcase)
      Anon.reset_column_information() 
      @forms += Anon.find(:all, :conditions=>"flow_id=#{flow.id} and user_id = #{current_user.id}", :order=>"id desc")
    end
    @forms.sort!{|a, b| b.created_at <=> a.created_at}
  end
  
  #我处理过的流程
  def myprocessed_form
    @forms = []
    
    for flow in Workflow.find(:all, :conditions=>"ischild <> 1 or ischild is null")
      next if !flow.formtable
      Anon.set_table_name("workflow_" + flow.formtable.code.downcase)
      Anon.reset_column_information() 
      @forms += Anon.find_by_sql("select f.* from workflow_#{flow.formtable.code.downcase} f left join workflow_history h on f.id = h.form_id where f.flow_id=#{flow.id} and h.user_id = #{current_user.id} and f.user_id<>#{current_user.id} group by f.id")
    end
    @forms.sort!{|a, b| b.updated_at <=> a.updated_at}
    @forms = @forms[0, 40] if !params[:all]
  end
  
  #已结束的流程（所有）
  def myfinished_form_all
    @flows = []
    for flow in Workflow.find(:all, :conditions=>"ischild <> 1 or ischild is null")
      wf = FlowMeta::LoadWorkFlow(flow.name, flow.content)
      if !wf.end_state.limit_type
        @flows << flow
      elsif wf.end_state.limit_type == "right"
        @flows << flow if current_user.rights.collect{|r| r.name}.include?(wf.end_state.limit) || wf.end_state.limit.to_s.size == 0
      elsif wf.end_state.limit_type == "fix_user"
        @flows << flow if wf.end_state.limit.to_i == current_user.id || wf.end_state.limit.to_s.size == 0
      end
    end
  end
  
  #已结束的流程（某一类）
  def myfinished_form
    @flow = Workflow.find(params[:id])
    Anon.set_table_name("workflow_" + @flow.formtable.code.downcase)
    Anon.reset_column_information() 
    @forms = Anon.paginate :conditions=>"flow_id=#{@flow.id} and _state = '结束'", :order=>"id desc", :page=>params[:page], :per_page=>20
  end
  
  #等待我处理的阅知
  def mywaiting_yuezhi
    if current_user.login == "admin1"     #管理员全看见
      @yuezhis = WorkflowYuezhi.paginate_by_sql("select * from workflow_yuezhi where memo is  null order by created_at desc ",:per_page=>10, :page => params[:page])
    else
      @yuezhis = WorkflowYuezhi.paginate_by_sql("select * from workflow_yuezhi where  user_id = #{current_user.id} and memo is  null order by created_at desc ",:per_page=>10, :page => params[:page])
    end
  end
  
  #查看某个工作流的表单
  def show_form
    @flow = Workflow.find(params[:flowid])
    Anon.set_table_name("workflow_" + @flow.formtable.code.downcase)
    Anon.reset_column_information() 
    @form_record = Anon.find(params[:formid])
     
    if @flow.flow_type == "固定流"
      state_name = @form_record._state.gsub(/\(.+\)/, '').split(',')[0] 
      if !state_name.index('-')   #子流程界面
        interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{@flow.id} and state_name = '#{state_name}'")
      else
        v = state_name.split('-')
        f = Workflow.find_by_name(v[0])
        interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{f.id} and state_name = '#{v[1]}'")
      end
      interface_xml = interface.form.text rescue nil
    elsif @flow.flow_type == "任意流"
      interface_xml = @flow.formtable.text rescue nil
    end
    
    if interface_xml
      form = GTable.new(interface_xml)
      @style = form.to_s(:style)
      @html  = form.to_s(:show, @form_record)
      @historys = WorkflowHistory.find(:all, :conditions=>"flow_id=#{params[:flowid]} and form_id = #{params[:formid]}")
    else
      render :text=>"没有上传工作流界面"
    end
  end
  
  #处理阅知
  def yuezhi_form
    if request.get?
      @flow = Workflow.find(params[:flowid])
      Anon.set_table_name("workflow_" + @flow.formtable.code.downcase)
      Anon.reset_column_information()
      @record_form = Anon.find(params[:formid])

      state_name = @record_form._state.gsub(/\(.+\)/, '').split(',')[0]

      if @flow.flow_type == "固定流"
        if !state_name.index('-')   #子流程界面
          interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{@flow.id} and state_name = '#{state_name}'")
        else
          v = state_name.split('-')
          f = Workflow.find_by_name(v[0])
          interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{f.id} and state_name = '#{v[1]}'")
        end
        interface_xml = interface.form.text rescue nil
      else
        interface_xml = @flow.formtable.text rescue nil
      end
      
      if interface_xml
        form = GTable.new(interface_xml)
        @style = form.to_s(:style)
        @html  = form.to_s(:show, @record_form)
        @historys = WorkflowHistory.find(:all, :conditions=>"flow_id=#{params[:flowid]} and form_id = #{params[:formid]}")
      else
        render :text=>"没有上传工作流界面"
      end
    elsif request.post?
      yuezhi = WorkflowYuezhi.find(params[:id])
      yuezhi.memo = params[:memo]
      yuezhi.save
      history = WorkflowHistory.new
      history.user_id = current_user.id
      history.flow_id = params[:flowid]
      history.form_id = params[:formid]
      history.process_time =Time.now
      history.state_name = "阅知"
      history.point = params[:memo]
      history.save
      flash[:notice] = "已处理阅知"
      redirect_to :action => "mywaiting_yuezhi"
    end
  end
  
  def print
    flow = Workflow.find(params[:id])
    Anon.set_table_name("workflow_" + flow.formtable.code.downcase)
    Anon.reset_column_information()
    form_record = Anon.find(params[:forms])
    
    
    flow = Workflow.find(params[:id])
    if !params[:forms]
      render :text=>"您没有选择记录"
      return
    end
    
    params[:forms] = [ params[:forms] ] if params[:forms].class == String

    Anon.set_table_name("workflow_" + flow.formtable.code.downcase)
    Anon.reset_column_information() 
    forms = Anon.find(:all, :conditions=>"id in (#{params[:forms].join(',')})")
    if forms.size == 0
      render :text=>"发生错误，没有取到记录"
      return 
    end
    if flow.flow_type == "固定流"
      interface = WorkflowInterface.find(:first, :conditions=>"flow_id=#{flow.id} and state_name = '开始'")
      interface_xml = interface.form.text
    elsif flow.flow_type == "任意流"
      interface_xml = flow.formtable.text
    end
    
    @htmls = []
    if interface_xml
      form = GTable.new(interface_xml)
      @style = form.to_s(:style)
      for f in forms
        @htmls << form.to_s(:show, f)
      end
      render :layout=>"notoolbar"
    else
      render :text=>"发生错误，没有取到界面"
      return 
    end
  end
  
private
  #判断用户在某一个状态是否拥有权限
  def check_state_right(flow, state_name)
    state = flow.get_state(state_name)
    return false if !state

    return true if state.limit_type == "right" && state.limit.to_s == ''      #没有限制
    if state.limit_type == "right"                                            #按权限
       if state.limit == "分管领导"
          d = Department.find(:first, :conditions=>"parent_leader = #{current_user.id}")
          return true if d
       elsif state.limit == "发起人"
          return true
       end
    elsif state.limit_type == "fix_user"                                      #固定人审批
          return true if state.limit.to_s == current_user.id.to_s
    elsif state.limit_type == "select_user"                                   #后期选人审批
    
    end
    return checkright(state.limit)
  end
  
  #获得某一种单据中所有等待当前登陆者审批的
  def get_wait_form(flowid)
    forms = []
    workflow = Workflow.find(flowid)
    if !workflow.formtable 
      return forms
    end
    Anon.set_table_name("workflow_" + workflow.formtable.code.downcase)
    Anon.reset_column_information() 

    flow = FlowMeta::LoadWorkFlow(workflow.name, workflow.content)
    flow.expand_all                     #展开子流程

    rights = current_user.rights.collect{|r| r.name}
    for state in flow.states
      next if state.name == "结束"
      
      conditions = []
      conditions << "_state='#{state.name}'"
      
      #如果可以从多个状态转移到这个状态，则等待所有状态都执行完此状态才可以执行
      if state.guest_trasits.size == 1      #只可以从一个状态转到这里
        conditions << " _state like '%,#{state.name}%'"
        conditions << "_state like '%#{state.name},%'"
      end
      
      #查找需要登录人会签的流程
      if state.huiqian == "1"
        conditions << " _state like '%#{current_user.name}_%'"
        conditions << " _state like '%_#{current_user.name}%'"
        conditions << " _state like '%(#{current_user.name})%'"
      end

      if state.limit_type == "right"   #按照权限审批
        if state.limit == "分管领导"
          all_forms = Anon.find(:all, :conditions=>conditions.join(' or '), :order=>"id desc")
          for form in all_forms
            forms << form if form.user.fg_leader.id == current_user.id rescue nil
          end
        elsif state.limit == "发起人"
          for form in Anon.find(:all, :conditions=>conditions.join(' or '), :order=>"id desc")
            forms << form if form.userid == current_user.id
          end
        else
          if state.limit.to_s.size > 0       #有权限限制
              if rights.index(state.limit)
                for form in Anon.find(:all, :conditions=>conditions.join(' or '), :order=>"id desc")
                  next if state.same_department == "1" && current_user.department != form.user.department  #必须同部门
                  forms << form
                end
              end
          else                                #没有权限限制
            for form in Anon.find(:all, :conditions=>conditions.join(' or '), :order=>"id desc")
              next if state.same_department == "1" && current_user.department != form.user.department  #必须同部门
              forms << form
            end
          end
        end
      elsif state.limit_type == "fix_user"    #按照人审批
        if current_user.id == state.limit
          forms += Anon.find(:all, :conditions=>conditions.join(' or '), :order=>"id desc")
        end
      elsif state.limit_type == "select_user" #按照前期选择人审批
        selects = WorkflowSelect.find(:all, :conditions=>"user_id = #{current_user.id} and flow_id = #{flowid} and state = '#{state.name}'")
        if selects.size > 0
          condition = "(#{conditions.join(" or ")})"
          condition += " and id in (#{selects.collect{|s| s.form_id}.join(',')})"
          forms += Anon.find(:all, :conditions=>condition, :order=>"id desc")
        end
      end
    end
    forms.uniq!
    return forms
  end
end
