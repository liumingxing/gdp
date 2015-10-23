class CreateProjectVersion < ActiveRecord::Migration
  def self.up
    create_table :project_version, :primary_key => :id do |t|
       t.column :project_id, :integer                         #所属项目
       t.column :budgettype, :string, :limit=>10                #投资规划,估算,概算,预算
       t.column :text, :string, :limit=>100, :null=>false     #版本号
       t.column :current, :integer                            #当前使用版本号
       t.column :creator, :string, :limit=>100                #建立者 
       t.timestamps
    end
  end

  def self.down
    drop_table :project_version
  end
end
