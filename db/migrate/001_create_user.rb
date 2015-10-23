class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :user, :primary_key => :id do |t|
       t.column :login, :string, :limit=>100, :null=>false     #登陆账号
       t.column :name, :string, :limit=>100                   #真实名
       t.column :password, :string, :limit=>100               #密码
       t.column :company_id, :integer                         #公司id
       t.column :department_id, :integer                      #部门id
       t.column :style, :string, :limit=>100                  #界面风格，不填则为蓝(blue)
       t.column :resign, :integer                             #是否辞职
       t.column :last_login_time, :datetime                   #上次登陆时间
       t.timestamps
       
       t.index :login, :unique=>true
    end
    
    admin = User.create(:login=>"admin", :name=>"系统管理员", :password=>"21232f297a57a5a743894a0e4a801fc3")
  end

  def self.down
    drop_table :user
  end
end
