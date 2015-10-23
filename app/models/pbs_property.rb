class PbsProperty < ActiveRecord::Base
  #递归插入节点
  #实例方法
  #重载
  def insert_element(element)
    t = element.add_element "I"
    t.attributes["id"] = self.id
    self.attributes.each{|key, value|
      next if key == "created_at" || key == "updated_at"
      t.attributes[key] = value
    }
  end
end
