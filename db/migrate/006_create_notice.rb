class CreateNotice < ActiveRecord::Migration
  def self.up
    create_table :notice, :primary_key => :id do |t|
       t.column :title, :string, :limit=>200
       t.column :content, :text
       t.column :user_id, :integer
       t.column :publish_time, :datetime     
       t.timestamps
    end
  end

  def self.down
    drop_table :notice
  end
end
