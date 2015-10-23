class Workitem < ActiveRecord::Base
  belongs_to :user
  belongs_to :contract
  
  has_one :register,  :class_name=>"WorkitemRegister", :order=>"id desc"
  has_one :change,    :class_name=>"WorkitemChange",   :order=>"id desc"
  has_one :pay,       :class_name=>"WorkitemPay",      :order=>"id desc"
  has_one :clearing,  :class_name=>"WorkitemClearing", :order=>"id desc"
  has_one :report,    :class_name=>"WorkitemReport",   :order=>"id desc"
  has_one :warranty,  :class_name=>"WorkitemWarranty", :order=>"id desc"
end
