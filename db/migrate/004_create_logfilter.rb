class CreateLogfilter < ActiveRecord::Migration
  def self.up
    create_table :logfilter, :primary_key => :id do |t|
       t.column :controller, :string, :limit=>100
       t.column :action, :string, :limit=>100
       t.column :desc, :string, :limit=>200
       t.column :log, :integer, :default=>1, :null=>false     #为1则写日志，否则不写              
       t.timestamps
    end
    
    create_table :log, :primary_key => :id do |t|
      t.column :username, :string, :limit=>100
      t.column :description, :string, :limit=>200
      t.column :url, :string, :limit=>100
      t.column :ip, :string, :limit=>100
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :logfilter
    drop_table :log
  end
end
