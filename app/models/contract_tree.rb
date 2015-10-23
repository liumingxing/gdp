class ContractTree < ActiveRecord::Base
  def ContractTree.import_initial(project_id, checked_array, t)
    roots = Hygh.find(:all, :conditions=>"project_id = #{project_id} and parent_id = 0 or parent_id is null")
    for root in roots
      next if checked_array && !checked_array.include?(root.id.to_s)
      copy_node(root, project_id, nil, checked_array, t)
    end
  end
  
  def ContractTree.copy_node(parent, project_id, parent_id, checked_array, t)
    node            = ContractTree.new
    node.project_id = project_id
    node.name       = parent.name 
    node.parent_id  = parent_id
    node.treetype   = t
    node.hygh_id    = parent.id
    node.position   = parent.position
    node.save
    for child in parent.children
      next if checked_array && !checked_array.include?(child.id.to_s)
      copy_node(child, project_id, node.id, checked_array, t)
    end
  end
end
