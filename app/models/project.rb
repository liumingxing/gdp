class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table=>"project_user"                          #参与者，负责人，监控人
  
  #投资规划树根节点集合
  def tzgh
    ProjectTzgh.find(:all, :conditions=>"project_id = #{self.id} and parent_id is null")
  end
  
  #判断某人在本项目中的权限
  def right_of(user_id, right_type)
    v = ProjectRight.find(:first, :conditions=>"project_id=#{self.id} and user_id=#{user_id} and right_type = '#{right_type}'")
    return v.right if v
    return ''
  end
  
  #获得本项目的当前版本
  def current_version(budgettype=nil)
    if budgettype
      version = ProjectVersion.find(:first, :conditions=>"project_id = #{self.id} and budgettype = '#{budgettype}' and current = 1")
    else
      version = ProjectVersion.find(:first, :conditions=>"project_id = #{self.id} and budgettype is null and current = 1")
    end
    if version
      version
    else
      ProjectVersion.create(:project_id => self.id, :budgettype => budgettype, :text=>'1', :current => 1, :creator=>'自动创建')
    end
  end
  
  #设置本项目的当前版本
  def set_current_version(version_id, budgettype=nil)
    ProjectVersion.update_all "current = 0", "project_id = #{self.id} and budgettype = '#{budgettype}'"
    version = ProjectVersion.find(version_id)
    version.current = 1
    version.save
  end
  
  #将投资规划树形导入到估概预算
  def import_initial(budgettype, checked_array=nil)
    version = current_version(budgettype)
    for root in self.tzgh
      next if checked_array && !checked_array.include?(root.id.to_s)
      copy_node(root, budgettype, version.id, nil, checked_array)
    end
  end
  
  def copy_node(root, budgettype, version_id, parent_id=nil, checked_array=nil)
    node            = ProjectBudget.new
    node.project_id = self.id
    node.version_id = version_id
    node.budgettype = budgettype
    node.tzgh_id    = root.id
    node.name       = root.name 
    node.parent_id  = parent_id
    node.position   = root.position
    node.pbs_id     = root.pbs_id
    node.pbs_node_id= root.pbs_node_id
    node.save
    for child in root.children
      next if checked_array && !checked_array.include?(child.id.to_s)
      copy_node(child, budgettype, version_id, node.id)
    end
  end
  
  #估概预算项复制一份到新版本中
  def copy_to_version(version_id, budgettype)
    #先清空
    ProjectBudget.delete_all "version_id = #{version_id}"
    
    roots = ProjectBudget.find(:all, :conditions=>"parent_id is null and project_id = #{self.id} and version_id = #{current_version(budgettype).id}")
    for root in roots
      copy_child(root, nil, version_id)
    end
  end
  
  def copy_child(from, parent_id, version_id)
    node = ProjectBudget.new
    from.attributes.each{|key, value|
        next if key == "id"
        node[key] = value
    }
    node.parent_id  = parent_id
    node.version_id = version_id
    node.save
    
    #插入project_budget_unit
    for unit in from.units
      u = ProjectBudgetUnit.new
      unit.attributes.each{|key, value|
        next if key == "id"
        u[key] = value
      }
      u.budget_item_id = node.id
      u.save
    end
    
    for child in from.children
      copy_child(child, node.id, version_id)
    end
  end
end
