require 'rexml/document'
require "State"
require "Trasit"
require "Flow"
require "pp"

include REXML

class Flow 
  attr_accessor :name
  attr_reader :trasits, :states, :start, :end_state
  def initialize(name, xmlstr)
  	@name = name
  	
  	#存放所有状态，包括开始状态和结束，开始状态放在第一个，结束状态放在最后
  	@states = Array.new
  	@trasits = Array.new
  	
  	#载入XML文档
  	doc = Document.new(xmlstr)
  	
  	#开始解析doc文档
  	root = doc.root
  	
  	#解析开始状态节点
  	root.elements.each("start") {|element|
  		start = State.start
  		start.name = "开始"
        start.enter = element.attributes["enter"]
  		start.leave = element.attributes["leave"]
  		start.limit = element.attributes["limit"]
  		start.limit_type = element.attributes["limit_type"]
  		start.select_next = element.attributes["select_next"]
  		@start = start
  		@states << start
  		break
  	}
  	
  	#解析所有状态节点
  	root.elements.each("state") {|element|
  		state = State.new
  		state.name = element.attributes["name"]
  		state.limit = element.attributes["limit"]
  		state.enter = element.attributes["enter"]
  		state.leave = element.attributes["leave"]
  		state.limit_type = element.attributes["limit_type"] 
  		state.select_next = element.attributes["select_next"]
  		state.same_department = element.attributes["same_department"]
  		state.huiqian = element.attributes["huiqian"] 
  		state.time = element.attributes["time"] 
  		@states << state
  	}
  	
  	#解析结束状态节点
  	root.elements.each("end") {|element|
  		end_node = State.new
  		end_node.name = "结束"
        end_node.limit = element.attributes["limit"]
  		end_node.enter = element.attributes["enter"]
  		end_node.limit_type = element.attributes["limit_type"]
  		end_node.select_next = element.attributes["select_next"]
  		end_node.same_department = element.attributes["same_department"]
  		@end_state = end_node
  		@states << end_node
  	}
  	
  	#解析子流程状态节点
  	root.elements.each("children") {|element|
  		state = State.new
  		state.name = element.attributes["name"]
        state.right = element.attributes["right"]
  		state.enter = element.attributes["enter"]
  		state.is_child = true;
  		@states << state
  	}
  	
  	#解析所有流转
  	root.elements.each("trasit") {|element|
  		from_name = element.attributes["from"]
  		to_name = element.attributes["to"]  		
  		
  		from_node = nil
  		to_node   = nil
  		for state in @states
  			if state.name == from_name
  				from_node = state
  			end
  			if state.name == to_name
  				to_node = state
  			end
  		end  		
  		
  		trasit = Trasit.new(from_node, to_node)
  		trasit.name = element.attributes["name"]
  		trasit.condition = element.attributes["condition"]  	
  		
  		from_node.trasits << trasit
  		to_node.add_guest_trasit(trasit)
  		@trasits << trasit	
  	}
  end
  
  def start
    @states[0]
  end
  
  def get_state(name)
    for state in @states
      return state if state.name == name
    end
    nil
  end
  
  def expand_all
    for state in @states
      expand(state.name)
    end
  end
  
  #进行子流程扩展
  def expand(state_name)
    state = get_state(state_name)
    if state.is_child         #是子流程
      record = YtwgWorkflow.find(:first, :conditions=>"name='#{state_name}' and is_child = 1")
      flow = Flow.new(state_name, record.content)
      @states += flow.states
      @trasits += flow.trasits
      for trasit in state.guest_trasits
        trasit.to = flow.start
      end
      flow.start.guest_trasits = state.guest_trasits
      
      for trasit in state.trasits
        trasit.from = flow.end_state
      end
      flow.end_state.trasits = state.trasits
      
      for state in flow.states
        state.name = state_name + "-" + state.name
      end
    end
  end
end