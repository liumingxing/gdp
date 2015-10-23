#内部消息
class CreateMessage < ActiveRecord::Migration
  def self.up
    create_table :message, :primary_key => :id do |t|
       t.column :user_id, :integer              #项目id
       t.column :sender, :string, :limit=>100   #发送人
       t.column :title, :string, :limit=>100    #标题
       t.column :text, :text                    #内容
       t.column :isread, :integer, :default=>0    #是否已读
       t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :message
  end
end