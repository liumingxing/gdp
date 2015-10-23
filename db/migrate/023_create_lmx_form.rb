#电子表单
class CreateLmxForm < ActiveRecord::Migration
  def self.up
    create_table :lmx_form, :primary_key => :id do |t|
       t.column :code, :string, :limit=>100                             #表单代码
       t.column :name, :string, :limit=>100                             #表单名称
       t.column :table, :string, :limit=>100                            #关联表名称
       t.column :form_type, :string, :limit=>100                        #表单类型 电子表单，任意流审批表单
       t.column :text, :text                                            #表单体xml文本
       t.timestamps
    end
  end

  def self.down
    drop_table :lmx_form
  end
end