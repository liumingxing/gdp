class Menu < ActiveRecord::Base
  acts_as_tree :foreign_key =>"parent_id", :order=>"position"
 
  
  #包括自身节点的所有子节点
  def all_children(empower='')
    result = [self]
    for child in self.children
      result += [child] if child.empower && child.empower.index(empower)
      if child.children.size > 0
        result += child.all_children(empower)
      end
    end
    result
  end
  
  def name
    self.text
  end
  
  def root
    node = self
    while node.parent
      node = node.parent
    end
    node
  end
end
