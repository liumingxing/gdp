
class FlowProcess 
  attr_accessor :user, :form
  
  def initialize(flow, form, state_name='开始')
    @flow = flow
    @state_name = state_name
    @form = form
    @user = nil
  end
  
  def update_form(value_hash)
    @form.update(value_hash)
  end
  
  #触发初始事件
  def signal_start
    state = @flow.get_state("开始")
    instance_eval(state.enter) if state.enter
  end
  
  #触发进入事件
  def signal_enter
    current_state = @flow.get_state(@state_name)
    instance_eval(current_state.enter) if current_state.enter
  end
  
  #触发离开事件
  def signal_leave(trasit_name='', jbr=nil)
    newstate = @form._state.split(',')
    if @state_name =~ /\(.+\)/     #包含有会签经办人信息
      newstate.delete(@state_name)
      jbrs = @state_name.scan(/\(.+\)/)[0].delete("()").split("_")
      jbrs.delete_if{|j| j == @user.name}
      if jbrs.size > 0
        newstate << @state_name[0, @state_name.index('(')] + "(" + jbrs.join("_") + ")"
        @form._state = newstate.join(',')
        @form.save
        return
      else
        newstate << @state_name[0, @state_name.index('(')]
        @state_name = @state_name[0, @state_name.index('(')]
        @form._state = newstate.join(',')
        @form.save
      end
    end

    current_state = @flow.get_state(@state_name)
    
    if !trasit_name || trasit_name == ''        #没指定下步走向
      for trasit in current_state.trasits
        if instance_eval(trasit.condition) || trasit.condition.size ==0
          newstate << trasit.to.name
          instance_eval(current_state.leave) if current_state.leave   #执行离开函数
        end
      end
    else                                        #指定下步走向
      for trasit in current_state.trasits
        if trasit_name == trasit.to.name
          if !jbr || jbr==''                    #指定了经办人
            newstate << trasit.to.name
          else
            newstate << trasit.to.name + "(#{jbr})"
          end
          
          instance_eval(current_state.leave) if current_state.leave    #执行离开函数
        end
      end
    end 
    newstate.delete(@state_name)
    newstate.uniq!
    
    if newstate.size > 0
      @form._state = newstate.join(',')
      @form.save
    end
  end
  
  #离开一个状态时触发的事件
  def signal
    current_state = @flow.get_state(@state_name)
    for trasit in current_state.trasits
      YtLog.info trasit.condition
      if instance_eval(trasit.condition) || trasit.condition.size ==0
        @state_name = trasit.to.name
        @form._state = @state_name
        
        #执行离开函数
        YtLog.info current_state.leave
        instance_eval(current_state.leave)
        
        #执行目的状态的进入函数
        YtLog.info trasit.to.enter
        instance_eval(trasit.to.enter)
        
        @form.save
        break
      end
    end
  end
  
  def method_missing(method_id, *args)
    name = method_id.id2name
    YtLog.info name, "method missing"
    YtLog.info @form[name]
    @form[name]
  end
end