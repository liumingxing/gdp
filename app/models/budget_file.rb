class BudgetFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  file_column :path
end
