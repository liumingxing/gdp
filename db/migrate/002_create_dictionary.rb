class CreateDictionary < ActiveRecord::Migration
  def self.up
    create_table :dictionary, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100
       t.timestamps
    end
    
    create_table :dictionary_item, :primary_key => :id do |t|
       t.column :dictionary_id, :integer
       t.column :name, :string, :limit=>100
       t.column :code, :string, :limit=>100
       t.timestamps
    end
    
    d = Dictionary.create(:name=>"项目权限")
    for item in %w(项目监控人 估算参与人 概算参与人 预算参与人 结算参与人 合同参与人 招标参与人 费用参与人 资金计划参与人 资金支付参与人)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"建筑类型")
    for item in %w(办公建筑 宾馆建筑 城市道路 地产项目 地铁项目 工业建筑 公共建筑 居住建筑 商业建筑 室外总体、公共绿地 学校建筑 医院建筑)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"结构类型")
    for item in %w(砖混结构 框架结构 砖木结构 钢结构 土木结构 框剪结构 框架短肢墙结构 剪力墙结构 框架筒体结构 排架结构 全现浇结构)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"建筑形状")
    for item in %w(矩形 L形 十字形 U形 环形 圆形 其它)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"装修标准")
    for item in %w(普通装修 中等装修 高档装修)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"屋面形式")
    for item in %w(平屋面不上人 平屋面上人 坡屋面)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"基础形式")
    for item in %w(条基 桩基 独立基础 箱基 筏基 满堂筏基 满堂板式基础 有梁筏板基础)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"外墙保温")
    for item in %w(聚苯板 挤塑聚苯板 保温砂浆 其它)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"外墙装饰")
    for item in %w(涂料 乳胶漆 瓷砖 石材 铝塑板 幕墙 其它)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"外窗类型")
    for item in %w(木窗 铝合金窗 塑钢窗 钢窗 其它)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"费用类型")
    for item in %w(工程费用 其他费用)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"估算依据")
    for item in %w(建筑面积 占地面积 地上面积 地下面积 室外总体面积 道路面积 地面停车面积 绿化面积 广场面积 水面面积 道路长度 跨线桥长 匝道桥长)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"计量单位")
    for item in %w(m2 m kg m3 t 个 台 元 座)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"工程费用类型")
    for item in %w(安装工程费 建筑工程费 设备购置费 其他费)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"合同类型")
    for item in %w(工程承包合同 材料采购合同 设备购置合同 机械租赁合同 劳务发包合同 勘察设计合同 咨询服务合同)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"变更支付方式")
    for item in %w(结算支付 过程支付)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"合同操作")
    DictionaryItem.create(:dictionary_id=>d.id, :name=>"签定", :code=>"register")
    DictionaryItem.create(:dictionary_id=>d.id, :name=>"变更", :code=>"change")
    DictionaryItem.create(:dictionary_id=>d.id, :name=>"统计", :code=>"report")
    DictionaryItem.create(:dictionary_id=>d.id, :name=>"支付", :code=>"pay")
    DictionaryItem.create(:dictionary_id=>d.id, :name=>"结算", :code=>"clearing")
    DictionaryItem.create(:dictionary_id=>d.id, :name=>"保修", :code=>"warranty")
    
    d = Dictionary.create(:name=>"公司专业")
    for item in %w(土建 装饰 安装 市政 绿化 仿古 其他)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"变更类型")
    for item in %w(设计变更 现场签证 索赔 其他)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
    
    d = Dictionary.create(:name=>"公司类型")
    for item in %w(股份合作公司 股份有限公司 国有企业 集体企业 联营企业 其他企业 私营企业 外资企业（含港澳台） 有限责任公司)
      DictionaryItem.create(:dictionary_id=>d.id, :name=>item)
    end
  end

  def self.down
    drop_table :dictionary
    drop_table :dictionary_item
  end
end
