class Message < ActiveRecord::Base
  def Message::count_of(id)
    Message.count :conditions=>"user_id = #{id} and isread = 0"
  end
end
