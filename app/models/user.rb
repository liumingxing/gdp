class User < ActiveRecord::Base
  has_and_belongs_to_many :roles, :join_table=>"role_user"
  belongs_to :company
  belongs_to :department
  
  def check_password(pass)
    return true if User.enc_password(pass) == self.password
    return false
  end
  
  def User.enc_password(pass)
    digest = Digest::MD5.new
    digest << pass
    digest.hexdigest
  end
  
  def truename
    self.name
  end
  
  def rights
    result = []
    for role in roles
      result += role.rights
    end
    result
  end
end
