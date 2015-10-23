include GridRecord
class PbsTemplate < ActiveRecord::Base
  acts_as_tree :order=>"position"
  
  #根节点
  def PbsTemplate.roots
    PbsTemplate.find(:all, :conditions=>"parent_id is null or parent_id = 0")
  end
  
  #递归插入节点(单项工程模板)
  def insert_price_element(element, pbs_id, collection)
    t = element.add_element "I"
    node = PbsNode.find(:first, :conditions=>"pbs_id=#{pbs_id} and template_id = #{self.id}")
    t.attributes["name"] = self.name
    t.attributes["id"]   = node.id
    t.attributes["basis"]= node.basis
    t.attributes["unit"] = node.unit
    t.attributes["price"]= node.price
    t.attributes["desc"] = node.desc
    
    for child in self.children
      next if !collection.include?(child.id)
      child.insert_price_element(t, pbs_id, collection)
    end
  end
end
