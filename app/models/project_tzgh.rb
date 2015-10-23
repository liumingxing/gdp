include GridRecord

class ProjectTzgh < ActiveRecord::Base
  acts_as_tree :order=>"position"
  
  def ProjectTzgh.roots(project_id)
    ProjectTzgh.find(:all, :conditions=>"project_id = #{project_id} and (parent_id is null or parent_id = 0)")
  end
  
  #递归插入分析节点
  def insert_analysis_element(element)
    t = element.add_element "I"
    t.attributes["Def"]  = "Node" if self.children.size > 0
    t.attributes["name"] = self.name
    t.attributes["id"]   = self.id
    
    project = Project.find(self.project_id)
    
    sum1 = sum2 = sum3 = 0
    
    b1 = ProjectBudget.find(:first, :conditions=>"project_id = #{project.id} and version_id = #{project.current_version(1).id} and tzgh_id = #{self.id}")
    sum1 = b1.jzgcf.to_f + b1.azgcf.to_f + b1.sbgzf.to_f + b1.qtfy.to_f if b1
    t.attributes["sum1"] = sum1
    
    b2 = ProjectBudget.find(:first, :conditions=>"project_id = #{project.id} and version_id = #{project.current_version(2).id} and tzgh_id = #{self.id}")
    sum2 = b2.jzgcf.to_f + b2.azgcf.to_f + b2.sbgzf.to_f + b2.qtfy.to_f if b2
    t.attributes["sum2"] = sum2
    if sum1 == sum2 && sum2 != 0
      t.attributes["sum2HtmlPrefix"] = "<span style='color:red;font-weight:bold;'>"
      t.attributes["sum2HtmlPostfix"] = "</span>"
    end
    
    b3 = ProjectBudget.find(:first, :conditions=>"project_id = #{project.id} and version_id = #{project.current_version(3).id} and tzgh_id = #{self.id}")
    sum3 = b3.jzgcf.to_f + b3.azgcf.to_f + b3.sbgzf.to_f + b3.qtfy.to_f if b3
    t.attributes["sum3"] = sum3
    if sum2 == sum3 && sum3 != 0
      t.attributes["sum3HtmlPrefix"] = "<span style='color:red;font-weight:bold;'>"
      t.attributes["sum3HtmlPostfix"] = "</span>"
    end
    
    t.attributes["subAB"] = sum1 - sum2
    t.attributes["subBC"] = sum2 - sum3
    t.attributes["subAC"] = sum1 - sum3
    t.attributes["subABPercent"] = (sum1 - sum2)*100/sum1 if sum1 != 0
    t.attributes["subBCPercent"] = (sum2 - sum3)*100/sum2 if sum2 != 0
    t.attributes["subACPercent"] = (sum1 - sum3)*100/sum1 if sum1 != 0
    
    for child in self.children
      child.insert_analysis_element(t)
    end
  end
  
  #递归插入版本比较节点
  def insert_version_compare_element(element, version_id1, version_id2, t)
    t = element.add_element "I"
    t.attributes["Def"]  = "Node" if self.children.size > 0
    t.attributes["name"] = self.name
    t.attributes["id"]   = self.id
    
    b1 = ProjectBudget.find(:first, :conditions=>"project_id = #{self.project_id} and version_id = #{version_id1} and tzgh_id = #{self.id}")
    t.attributes["sum1"] = b1.sum
    b2 = ProjectBudget.find(:first, :conditions=>"project_id = #{self.project_id} and version_id = #{version_id2} and tzgh_id = #{self.id}")
    t.attributes["sum2"] = b2.sum
    t.attributes["sub12"] = b1.sum - b2.sum
    for child in self.children
      child.insert_version_compare_element(t, version_id1, version_id2, t)
    end
  end
end
