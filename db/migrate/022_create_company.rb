#公司
class CreateCompany < ActiveRecord::Migration
  def self.up
    create_table :company, :primary_key => :id do |t|
       t.column :name, :string, :limit=>100                             #企业名称
       t.column :alias, :string, :limit=>100                            #系统别名
       t.column :company_type, :string, :limit=>100                     #公司性质
       t.column :area, :string, :limit=>20                              #企业总部所在地
       t.column :fax, :string, :limit=>100                              #传真
       t.column :homepage, :string, :limit=>200                         #主页
       t.column :register_fund, :float                                  #注册资金（万元）
       t.column :post_code, :string, :limit=>20                         #邮政编码
       t.column :grade, :string, :limit=>100                            #资质等级
       t.column :business_number, :string, :limit=>100                  #工商注册号
       t.column :address, :string, :limit=>200                          #地址
       t.column :linker, :string, :limit=>20                            #联系人
       t.column :telephone, :string, :limit=>20                         #联系电话
       t.column :desc, :text                                            #公司简介       
       t.column :is_delete, :boolean
       t.timestamps
    end
  end

  def self.down
    drop_table :company
  end
end