class Notice < ActiveRecord::Base
  set_table_name :notice
  #has_and_belongs_to_many :users, :join_table=>"user_notice", :association_foreign_key =>'user_id',  :foreign_key=>'notice_id'
end
