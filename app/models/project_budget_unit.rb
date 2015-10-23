class ProjectBudgetUnit < ActiveRecord::Base
  belongs_to :budget, :class_name=>"ProjectBudget", :foreign_key=>"budget_item_id"
end
