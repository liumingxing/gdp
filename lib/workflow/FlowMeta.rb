$LOAD_PATH.unshift(File.dirname(__FILE__))

require "Flow"

class FlowMeta
  class << self
    $Workflows = {}
    
    def LoadAllFlows()
      puts "loading all workflow..."
      $Workflows.clear
      flows = YtwgWorkflow.find(:all)
      for flow in flows
        LoadWorkFlow(flow.name, flow.content.sub('<?xml version="1.0" encoding="gb2312" ?>', ''))
        #LoadWorkFlow(flow.name, flow.content)
      end
    end
		
    def LoadWorkFlow(name, str)
      puts name
      flow = Flow.new(name, str)
      flow.expand_all
      $Workflows[name] = flow
      flow
    end
		
    def Remove(name)
      $Workflows.delete(name)
    end
  end
end