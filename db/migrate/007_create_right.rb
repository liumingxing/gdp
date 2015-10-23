class CreateRight < ActiveRecord::Migration
  def self.up
    #角色
    create_table :right, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100
       t.column :description, :string, :limit=>100
       t.column :position, :integer 
       t.timestamps
    end
    
    #权限
    create_table :role, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100
       t.column :description, :string, :limit=>100
       t.timestamps
    end
    
    #角色权限表
    create_table :right_role, :id => false do |t|
       t.column :role_id, :integer
       t.column :right_id, :integer
       t.timestamps
       
       t.add_index [:role_id, :right_id], :unique=>true
    end
    
    #人角色表
    create_table :role_user, :id => false do |t|
       t.column :user_id, :integer
       t.column :role_id, :integer
       t.timestamps
       
       t.add_index [:user_id, :role_id], :unique=>true
    end
  end

  def self.down
    drop_table :right
    drop_table :role
    drop_table :right_role
    drop_table :role_user
  end
end
