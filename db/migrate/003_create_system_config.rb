class CreateSystemConfig < ActiveRecord::Migration
  def self.up
    create_table :system_config, :primary_key => :id do |t|
       t.column :title, :string, :limit=>100
       t.column :visitedtimes, :integer
       t.column :logo, :string, :limit=>200
       t.column :address, :string, :limit=>200
       t.column :telephone, :string, :limit=>200
    end
    
    SystemConfig.create(:title=>"造价全过程管理系统", :visitedtimes=>0)
  end

  def self.down
    drop_table :system_config
  end
end
