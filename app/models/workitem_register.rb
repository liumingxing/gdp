class WorkitemRegister < ActiveRecord::Base
  belongs_to :user
  belongs_to :workitem
  
  def after_save
    workitem.amount = self.amount
    workitem.save
    workitem.contract.refresh
  end
end
