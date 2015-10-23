class ContractFile < ActiveRecord::Base
  belongs_to :contract
  file_column :path
end
