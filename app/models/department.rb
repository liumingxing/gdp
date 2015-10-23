class Department < ActiveRecord::Base
  belongs_to :leader, :class_name => "User", :foreign_key=>"leader_id"
  belongs_to :fg_leader, :class_name => "User", :foreign_key=>"parent_leader"
  has_many :users, :class_name =>"User", :order=>"id"
  acts_as_tree :foreign_key =>"parent_id" , :order=>"position"



  #category 部门(dep) 业务(biz)
  def self.telephone(category,param)
    if category == "dep"
      Department.find_by_name(param).phone 
    else
      "8888888"
    end
  end

  #category 部门(dep) 业务(biz)
  def self.fax(category,param)
    if category == "dep"
      Department.find_by_name(param).fax
    else
      "8888888"
    end
  end


  def zhuce_weiwancheng?
    false
  end

  def shenhetongguo?
    true
  end

end
