#文档资料
class CreateDoc < ActiveRecord::Migration
  def self.up
    create_table :doc, :primary_key => :id do |t|
       t.column :project_id, :integer             #项目id
       t.column :doc_type, :string, :limit=>100   #文档类型 project contract feiyong
       t.column :contract_id, :integer            #合同id
       t.column :name, :string, :limit=>100       #名称
       t.column :path, :string, :limit=>300       #文件路径
       t.column :user_id, :integer                #发布人
       t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :doc
  end
end