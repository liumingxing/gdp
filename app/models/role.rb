class Role < ActiveRecord::Base
  has_and_belongs_to_many :rights, :join_table=>"right_role"
end
