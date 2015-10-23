require 'rexml/document'

module GridRecord  
  #查找grid父节点，主要用于grid保存时使用
  #返回父节点id，值类型为数字，没有为null
  #类方法
  def find_grid_from_id(id_text)
     parent = self.find_by_id(id_text.split('$').last)
     
     if parent
       return parent.id
     else
       tmp_parent = self.find_by_tmpid(id_text)
       if tmp_parent
         return tmp_parent.id
       else
         return nil
       end
     end
  end
  
  #设置节点的顺序
  #实例方法
  def set_after(id)
    if id
      before = self.class.find(self.class.find_grid_from_id(id))
      self.class.update_all "position = position + 1", "parent_id=#{self.parent_id} and position > #{before.position}"   

      self.position = before.position + 1
      self.save
    else    #放在最前面
      if self.parent_id
          self.class.update_all "position = position + 1", "parent_id=#{self.parent_id}"   
      else
          self.class.update_all "position = position + 1", "parent_id is null or parent_id = 0"   
      end

      self.position = 0
      save
    end
  end
  
  #获得数据
  #类方法
  def get_data(root_condition)
    doc = REXML::Document.new("<Grid><Body><B></B></Body></Grid>")
    element = REXML::XPath.first(doc, "/Grid/Body/B")
    
    #投资规划
    roots = self.find(:all, :conditions=>root_condition)

    for root in roots
      root.insert_element(element)
    end
    str = ''
    doc.write(str)
    return str
  end
  
  #递归插入节点
  #实例方法
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
  
  #提交数据，类方法
  def upload_data(xml, *args)
    xml = xml.gsub("&lt;", "<").gsub("&gt;", ">")
    args = args[0]
    doc = REXML::Document.new(xml)
    REXML::XPath.match(doc, "/Grid/Changes/I").each{|e|
      if  e.attributes["Added"] == "1"                                       #添加
        budget            = self.new
        budget.attributes.each{|key, value| 
          next if key == "id"
          budget[key] = e.attributes[key] if e.attributes[key]
        }
           
        budget.tmpid      = e.attributes["id"]
        args.each{|key, value|
          budget[key.to_s] = value
        }
        budget.parent_id  = self.find_grid_from_id(e.attributes["Parent"])
        budget.save
      end
      
      if  e.attributes["Deleted"] == "1"                                       #删除
        budget = self.find(:first, :conditions=>"id='#{e.attributes['id'].split('$').last})'")
        budget.destroy if budget
      end
      
      if e.attributes["Changed"] == "1"                                        #修改
        budget = self.find(:first, :conditions=>"id='#{e.attributes['id'].split('$').last})'")
        if budget
           budget.attributes.each{|key, value| 
             next if key == "id"
             budget[key] = e.attributes[key] if e.attributes[key]
           }
           budget.save
        end
      end
      
      if e.attributes["Moved"] && e.attributes["Moved"].to_i > 0                #移动
        budget = self.find(:first, :conditions=>"id='#{e.attributes['id'].split('$').last})'")
        if budget
          budget.parent_id  = self.find_grid_from_id(e.attributes["Parent"])
          budget.set_after(e.attributes["Prev"].split('$').last)
        end
      end
    }
    
    return '<Grid><IO Result="0"/></Grid>'
  end
end