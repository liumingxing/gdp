class Tztemplate < ActiveRecord::Base
  has_many :nodes, :class_name=>"TztemplateNode", :foreign_key=>"template_id", :order=>"position"
  #树形结构根节点
  def item_roots
    TztemplateNode.find(:all, :conditions=>"parent_id is null and template_id = #{self.id}")
  end
end
