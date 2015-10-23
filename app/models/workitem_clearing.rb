class WorkitemClearing < ActiveRecord::Base
  belongs_to :user
  belongs_to :workitem
  
  def after_save
    workitem.amount = self.clearing_amount
    workitem.save
    workitem.contract.refresh
  end
end
