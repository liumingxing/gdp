class Area < ActiveRecord::Base
  acts_as_tree
  
  #  华北 东北
  def self.root_nodes
    find(:all, :conditions => ["parent_id = 0"])
  end

  #省份
  def self.provinces
    @provinces ||= Area.root_nodes.collect {|root| root.children}.flatten.compact
  end
  
  def self.citys_of(province_name)
    province = Area.find_by_text(province_name)
    if province
      province.direct_children
    else
      []
    end
  end

  def parent
    Area.find_by_id(self.parent_id)
  end

  class<<self
    alias  city_or_states provinces
  end
end
