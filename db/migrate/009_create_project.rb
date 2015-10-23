class CreateProject < ActiveRecord::Migration
  def self.up
    create_table :project, :primary_key => :id do |t|
       t.column :position, :integer                           #平级节点先后顺序
       t.column :name, :string, :limit=>100, :null=>false     #项目名称
       t.column :fzr_id, :integer                             #负责人
       t.column :gcdd, :string, :limit=>100                   #工程地点
       t.column :jzlx, :string, :limit=>100                   #建筑类型
       t.column :jglx, :string, :limit=>100                   #结构类型
       t.column :jzxz, :string, :limit=>100                   #建筑形状
       t.column :zxbz, :string, :limit=>100                   #装修标准
       t.column :zxbz, :string, :limit=>100                   #装修标准
       t.column :wmxs, :string, :limit=>100                   #屋面形式
       t.column :jcxs, :string, :limit=>100                   #基础形式
       t.column :wqbw, :string, :limit=>100                   #外墙保温
       t.column :wqzs, :string, :limit=>100                   #外墙装饰
       t.column :wclx, :string, :limit=>100                   #外窗类型
       t.column :jzmj, :integer                               #建筑面积
       t.column :dsmj, :integer                               #地上面积
       t.column :dxmj, :integer                               #地下面积
       t.column :zdmj, :integer                               #占地面积
       t.column :zcs, :integer                                #总层数
       t.column :dscs, :integer                               #地上层数
       t.column :dxcs, :integer                               #地下层数
       t.column :bzcg, :float                                 #标准层高
       t.column :lxpw, :string, :limit=>100                   #立项批准文号
       t.column :gszj, :decimal, :precision => 15, :scale => 2 #概算造价
       t.column :jsdw, :string, :limit=>100                   #建设单位
       t.column :sjdw, :string, :limit=>100                   #设计单位
       t.column :jldw, :string, :limit=>100                   #监理单位
       t.column :sjdw, :string, :limit=>100                   #审计单位
       t.column :zhms, :text                                  #综合描述
       t.column :establisher, :string, :limit=>100            #项目建立者
       t.timestamps
    end
    
    #项目参与人表
    create_table :project_user, :id => false do |t|
      t.column :user_id, :integer
      t.column :project_id, :integer
      t.column :created_at, :datetime
      
      t.add_index [:project_id, :user_id], :unique=>true
    end
    
    #参与人权限表
    create_table :project_right, :id => false do |t|
      t.column :project_id, :integer              #项目id
      t.column :user_id, :integer                 #参与人id
      t.column :right_type, :string, :limit=>100  #环节类型: 项目监控人 估算参与人 概算参与人 预算参与人 结算参与人 合同参与人 招标参与人 费用参与人 资金计划参与人 资金支付参与人
      t.column :right, :string, :limit=>100       #参与人，负责人
      t.column :created_at, :datetime
      
      t.add_index [:project_id, :user_id, :right_type], :unique=>true
    end
    
  end

  def self.down
    drop_table :project
    drop_table :project_user
    drop_table :project_right
  end
end
