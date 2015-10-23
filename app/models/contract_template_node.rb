include GridRecord

class ContractTemplateNode < ActiveRecord::Base
  acts_as_tree :order=>"position"
  
  #递归插入节点
  def insert_element(element)
    t = element.add_element "I"
    t.attributes["Def"] = "Node" if self.children.size > 0
    t.attributes["id"] = self.id
    self.attributes.each{|key, value|
      next if key == "created_at" || key == "updated_at"
      t.attributes[key] = value
    }

    for child in self.children
      child.insert_element(t)
    end
  end
  
  #查找grid父节点，主要用于grid保存时使用
  #返回父节点id，值类型为数字，没有为null
  def ContractTemplateNode.find_grid_from_id(id_text)
     parent = ContractTemplateNode.find_by_id(id_text.split('$').last)
     
     if parent
       return parent.id
     else
       tmp_parent = ContractTemplateNode.find_by_tmpid(id_text)
       if tmp_parent
         return tmp_parent.id
       else
         return nil
       end
     end
  end
  
  #设置节点的顺序
  def set_after(id)
    if id
      before = ContractTemplateNode.find(ContractTemplateNode.find_grid_from_id(id))
      ContractTemplateNode.update_all "position = position + 1", "parent_id=#{self.parent_id} and position > #{before.position}"   

      self.position = before.position + 1
      self.save
    else    #放在最前面
      if self.parent_id
          ContractTemplateNode.update_all "position = position + 1", "parent_id=#{self.parent_id}"   
      else
          ContractTemplateNode.update_all "position = position + 1", "parent_id is null or parent_id = 0"   
      end

      self.position = 0
      save
    end
  end
end
