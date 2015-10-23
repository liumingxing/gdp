include GridRecord
class Hygh < ActiveRecord::Base
  acts_as_tree
  has_many :units, :class_name=>"HyghUnit"
  
  #递归插入节点
  def insert_element(element)
    t = element.add_element "I"
    if self.children.size > 0
      t.attributes["Def"] = "ClassNode" 
    else
      if self.itemtype == 1
        t.attributes["Def"] = "LeafClassNode" 
      else
        t.attributes["Def"] = "LeafNode" 
      end
    end
    t.attributes["id"] = self.id
    self.attributes.each{|key, value|
      t.attributes[key] = value
    }
    
    for child in self.children
      child.insert_element(t)
    end
  end
  
  def Hygh.import_initial(project_id, checked_array=nil)
    roots = ContractTemplateNode.find(:all, :conditions=>"parent_id = 0 or parent_id is null")
    for root in roots
      next if checked_array && !checked_array.include?(root.id.to_s)
      copy_node(root, project_id, nil, checked_array)
    end
  end
  
  def Hygh.copy_node(parent, project_id, parent_id, checked_array)
    node            = Hygh.new
    node.project_id = project_id
    node.name       = parent.name 
    node.parent_id  = parent_id
    node.position   = parent.position
    node.itemtype   = parent.itemtype
    node.save
    for child in parent.children
      next if checked_array && !checked_array.include?(child.id.to_s)
      copy_node(child, project_id, node.id, checked_array)
    end
  end
  
  def unit_cost_sum
    result = 0
    for unit in self.units
      result += unit.cost
    end
    result
  end
  
end
