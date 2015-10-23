#电子表单
class CreateWorkflow < ActiveRecord::Migration
  def self.up
    create_table :workflow, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                             #工作流名称
       t.column :formtable_id, :integer                                 #数据库关联表名称
       t.column :flow_type, :string, :limit=>100                        #工作流类型:固定流， 任意流
       t.column :content, :text                                         #工作流xml
       t.column :position, :integer                                     #排列顺序
       t.column :ischild, :boolean                                      #是否子流程
       t.column :has_bigtext, :boolean                                  #是否含有正文域
       t.timestamps
    end
    
    create_table :workflow_file, :primary_key => :id do |t|             #工作流附件
       t.column :flow_id, :string, :limit=>100                          #工作流名称
       t.column :form_id, :integer                                      #表单id
       t.column :path, :string, :limit=>200                             #文件路径
       t.column :uploader, :string, :limit=>100                         #上传人
       t.column :created_at, :datetime                                  #上传时间
    end
    
    create_table :workflow_formback, :primary_key => :id do |t|         #打回
       t.column :flow_id, :integer                                      #工作流
       t.column :form_id, :integer                                      #表单id
       t.column :state, :string, :limit=>200                            #状态
       t.column :user, :string, :limit=>100                             #打回人
       t.column :created_at, :datetime                                  #打回时间
    end
    
    create_table :workflow_yuezhi, :primary_key => :id do |t|           #阅知
       t.column :flow_id, :integer                                      #工作流
       t.column :form_id, :integer                                      #表单id
       t.column :user_id, :integer                                      #阅知人
       t.column :state, :string, :limit=>200                            #状态
       t.column :users, :string, :limit=>100                            #所有阅知人
       t.column :memo, :text                                            #阅知意见
       t.column :creator, :string, :limit=>100                          #发起人
       t.column :created_at, :datetime                                  #上传时间
    end
    
    create_table :workflow_history, :primary_key => :id do |t|          #处理历史
       t.column :user_id, :integer                                      #处理人
       t.column :flow_id, :integer                                      #工作流
       t.column :form_id, :integer                                      #表单
       t.column :process_time, :datetime                                #处理时间
       t.column :memo, :string, :limit=>400                             #备注
       t.column :state_name, :string, :limit=>200                       #处理时的状态
       t.column :point, :string, :limit=>400                            #处理意见
    end
    
    create_table :workflow_select, :primary_key => :id do |t|           #先期选人的工作流记录
      t.column :user_id, :integer                                       #处理人id
      t.column :flow_id, :integer                                       #工作流id
      t.column :form_id, :integer                                       #表单id
      t.column :state, :string, :limit=>100                             #状态id
      t.column :created_at, :datetime                                   #创建时间
    end
  end

  def self.down
    drop_table :workflow
    drop_table :workflow_file
    drop_table :workflow_formback
    drop_table :workflow_yuezhi
    drop_table :workflow_history
    drop_table :workflow_select
  end
end