#合同文件
class CreateContractFile < ActiveRecord::Migration
  def self.up
    create_table :contract_file, :primary_key => :id do |t|
       t.column :contract_id, :integer              #项目id
       t.column :path, :string, :limit=>100     #路径
       t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :contract_file
  end
end