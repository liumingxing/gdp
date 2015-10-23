include GridRecord

class ProjectBudget < ActiveRecord::Base
  belongs_to :project
  belongs_to :version
  belongs_to :pbs
  belongs_to :fz_user, :class_name=>"User", :foreign_key=>"fzr"
  belongs_to :sh_user, :class_name=>"User", :foreign_key=>"shr"
  has_many   :units, :class_name=>"ProjectBudgetUnit", :foreign_key=>"budget_item_id"
  has_many   :files, :class_name=>"BudgetFile", :foreign_key=>"budget_id"
  
  acts_as_tree :order=>"position"
  
  def sum
    self.jzgcf.to_f + self.azgcf.to_f + self.sbgzf.to_f + self.qtfy.to_f 
  end
  
  #查找grid父节点，主要用于grid保存时使用
  #返回父节点id，值类型为数字，没有为null
  def find_grid_from_id(id_text)
     parent = ProjectBudget.find(:first, :conditions=>"project_id = #{self.project_id} and version_id=#{self.version_id} and id = '#{id_text.split('$').last}'") 

     if parent
       return parent.id
     else
       tmp_parent = ProjectBudget.find(:first, :conditions=>"project_id = #{self.project_id} and version_id=#{self.version_id} and tmpid = '#{id_text}'") 
       if tmp_parent
         return tmp_parent.id
       else
         return nil
       end
     end
  end
  
  #递归插入节点
  def insert_element(element)
    t = element.add_element "I"
    t.attributes["Def"] = "Node" if self.children.size > 0
    t.attributes["id"] = self.id
    self.attributes.each{|key, value|
      next if key == "created_at" || key == "updated_at"
      t.attributes[key] = value
    }

    t.attributes["jhsj"]  = self.jhsj.to_date.to_s if self.jhsj
    t.attributes["wcsj"]  = self.wcsj.to_date.to_s if self.wcsj
    if self.pbs_id && !self.pbs_node_id
      t.attributes["flag"] = "<img src='/img/flag_red.png' />"
    end
    
    for child in self.children
      child.insert_element(t)
    end
  end
  
  #设置节点的顺序
  def set_after(id)
    if id
      before = ProjectBudget.find(self.find_grid_from_id(id))

      if self.version_id              #估概预
        ProjectBudget.update_all "position = position + 1", "project_id = #{self.project_id} and parent_id=#{self.parent_id} and version_id = #{self.version_id} and budgettype = #{self.budgettype} and position > #{before.position}"   
      else                            #投资规划
        ProjectBudget.update_all "position = position + 1", "project_id = #{self.project_id} and parent_id=#{self.parent_id} and version_id is null and budgettype is null and position > #{before.position}"   
      end
      
      self.position = before.position + 1
      self.save
    else    #放在最前面
      if self.version_id              #估概预
        if self.parent_id
          ProjectBudget.update_all "position = position + 1", "project_id = #{self.project_id} and parent_id=#{self.parent_id} and version_id = #{self.version_id} and budgettype = #{self.budgettype}"   
        else
          ProjectBudget.update_all "position = position + 1", "project_id = #{self.project_id} and parent_id is null and version_id = #{self.version_id} and budgettype = #{self.budgettype}"   
        end
      else                            #投资规划
        if self.parent_id
          ProjectBudget.update_all "position = position + 1", "project_id = #{self.project_id} and parent_id=#{self.parent_id} and version_id is null and budgettype is null"   
        else
          ProjectBudget.update_all "position = position + 1", "project_id = #{self.project_id} and parent_id is null and version_id is null and budgettype is null"   
        end
      end
      self.position = 0
      save
    end
  end
  
  def unit_sum(feetype)
    result = 0
    for unit in self.units
      result += unit.num * unit.price * unit.rate if unit.feetype == feetype
      result += unit.num * unit.price * unit.rate if feetype == "其他费" && unit.feetype.to_s == ''
    end
    result
  end
  
end
