require 'gtable'
class LmxFormController < ApplicationController
  before_filter :modify_form, :only=>%w(edit_preview design get_attributes set_table_attribute set_cell_attribute merge split insert_row delete_row pack_style script_manager save_script set_float_row drop_table)
  after_filter :save_form, :only=>%w(set_table_attribute set_cell_attribute merge split insert_row delete_row pack_style save_script set_float_row)
  
  def modify_form
    @lmx_form = LmxForm.find(params[:id])
    @table = GTable.new(@lmx_form.text)
  end
  
  def save_form
    @lmx_form.text = @table.to_s(:xml)
    @lmx_form.save
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @lmx_forms = LmxForm.paginate :page=>params[:page], :per_page => 20
  end

  def new
    @lmx_form = LmxForm.new
  end

  def edit_preview
    
    @form = nil
    if params[:fid]
      Anon.set_table_name(@lmx_form.table)
      Anon.reset_column_information
      @form = Anon.find(params[:fid])
    end
  end
  
  def create
    @lmx_form = LmxForm.new(params[:lmx_form])
    table = GTable.new(params[:lmx_form][:code], params[:lmx_form][:name], params[:rows].to_i, params[:cols].to_i)
    @lmx_form.text = table.to_s(:xml)
    if @lmx_form.save
      redirect_to :action => 'design', :id=>@lmx_form
    else
      render :action => 'new'
    end
  end

  def update
    @lmx_form = LmxForm.find(params[:id])
    if @lmx_form.update_attributes(params[:lmx_form])
      flash[:notice] = '修改电子表单成功'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    LmxForm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def get_attributes
    @row = params[:row].to_i + 1
    @col = params[:col].to_i + 1
    
    render :layout=>false
  end
  
  #设置表属性，params[:row] 和 params[:col]从0开始计数
  def set_table_attribute
    if params[:field] == "表标识"
      @table.code = params[:value]
      @lmx_form.code = params[:value]
    elsif params[:field] == "表名称"
      @table.name = params[:value]
      @lmx_form.name = params[:value]
    elsif params[:field] == "行高"
      (params[:row1].to_i+1).upto(params[:row2].to_i + 1) do |row|
        @table.set_row_height(row, params[:value])
      end
    elsif params[:field] == "列宽"
      (params[:col1].to_i+1).upto(params[:col2].to_i + 1) do |col|
        @table.set_col_width(col, params[:value])
      end
    end
    
    render :partial=>"table", :locals=>{:refresh=>true}
  end
  
  def set_cell_attribute
      map={     "单元格名称"   => 'name',
                "单元格描述"   => 'title',
                "文本"        => 'text',
                "存储到数据库" => 'store',
                "单元格类型"   => 'type',
                "选择项"      => 'data',
                "必填"        => 'notnull',
                "只读"        => 'readonly',
                "显示千分位"   => 'thousand',
                "保留小数位"   => 'dot',
                "前置字符串"   => 'prefix',
                "后置字符串"   => 'postfix',
                "前景色"       => 'color',
                "背景色"      => 'background-color',
                "字体"        => 'font',
                "水平对齐"    => 'text-align',
                "垂直对齐"    => 'vertical-align',
                "自动折行"    => 'word-wrap',
                "背景图片"    => 'background-image',
                "上边框"     => 'border-top',
                "右边框"     => 'border-right',
                "下边框"     => 'border-bottom',
                "左边框"     => 'border-left' }
    field = map[params[:field]]

    @table.set_cell_attribute(params[:row1].to_i + 1, params[:col1].to_i + 1, params[:row2].to_i + 1, params[:col2].to_i + 1, field, params[:value])
    if field == "store" && params[:value] == "false"
      @table.set_cell_attribute(params[:row1].to_i + 1, params[:col1].to_i + 1, params[:row2].to_i + 1, params[:col2].to_i + 1, "background-color", "buttonface")
    elsif field == "store" && params[:value] == "true"
      @table.set_cell_attribute(params[:row1].to_i + 1, params[:col1].to_i + 1, params[:row2].to_i + 1, params[:col2].to_i + 1, "background-color", "white")
    end
    
    if params[:refresh] == "false"
      render :text=>""
    else
      render :partial=>"table", :locals=>{:refresh=>true}
    end
  end
  
  def merge
    @table.merge(params[:row1].to_i + 1, params[:col1].to_i + 1, params[:row2].to_i + 1, params[:col2].to_i + 1)
    render :partial=>"table", :locals=>{:refresh=>true}
  end
  
  def split
    @table.split(params[:row].to_i + 1, params[:col].to_i+1)    
    render :partial=>"table", :locals=>{:refresh=>true}
  end
  
  def insert_row
    @table.instance_eval("insert_#{params[:field]}(#{params[:row].to_i + 1})")
    render :partial=>"table", :locals=>{:refresh=>true}
  end
  
  def delete_row
    @table.instance_eval("delete_#{params[:field]}(#{params[:row].to_i + 1})")
    render :partial=>"table", :locals=>{:refresh=>true}
  end
  
  #压缩表风格
  def pack_style
    @table.pack
    render :partial=>"table", :locals=>{:refresh=>true}
  end
  
  #上传xml文件
  def upload
    if !params[:file] || params[:file].size == 0
      flash[:notice] = "请选择正确的文件"
      redirect_to :action=>"list"
      return
    end
    xml = params[:file].read
    @table = GTable.new(xml)
    
    @lmx_form = LmxForm.new
    @lmx_form.text = xml
    @lmx_form.code = @table.code
    @lmx_form.name = @table.name
    @lmx_form.save
    
    redirect_to :action=>"list"
  end
  
  #下载表单xml文件
  def download
    @lmx_form = LmxForm.find(params[:id])
    send_data @lmx_form.text, :filename=> "#{@lmx_form.name}.xml".to_gb2312
  end
  
  def make_table
    @lmx_form = LmxForm.find(params[:id])
    conn = ActiveRecord::Base.connection
    conn.create_table "lmx_#{@lmx_form.code.downcase}", :primary_key=>:id do |t|
      t.column "user_id", :integer                                                 #流程发起人的id
      t.column "flow_id", :integer                                                 #工作流id
      t.column "next_user_id", :integer                                            #下一步要审批的人
      t.column "_content", :text      if @lmx_form.form_type == '任意流审批表单'      #审批用正文域
      @table = GTable.new(@lmx_form.text)
      
      @table.input_cells{|cell, row_index, col_index|
        puts row_index
        puts col_index
        name = cell.attributes["name"]
        puts name
        name = ('A'[0]+col_index-1).chr + row_index.to_s if !name || name.size == 0
        puts name
        
        case cell.attributes["type"]
        when "integer"
          t.column name, :integer
        when "float"
          t.column name, :decimal, :precision => 15, :scale => 3 
        when "text"
          t.column name, :string, :limit=>255
        when "date"
          t.column name, :date
        when "datetime"
          t.column name, :datetime
        when "textarea"
          t.column name, :text
        when "select"
          t.column name, :text, :limit=>100
        when "check"
          t.column name, :boolean
        else                                    #默认是整形
          t.column name, :integer
        end
      }
      t.timestamps
    end
    
    1.upto(@table.rows_count) do |i|
      if @table.float_row?(i)
        conn.create_table "lmx_#{@lmx_form.code.downcase}_#{i}", :primary_key=>:id do |t|
          t.column "parent_id", :integer 
          @table.rows{|row, index|
            next if index != i
            1.upto(@table.cols_count) do |col|
              cell = row.elements[col]
              next if cell.attributes["store"] == "false"                       #不存储到数据库中
              next if cell.attributes["style"] == "display:none"                #被合并了
              name = cell.attributes["name"]
              name = ('A'[0]+col-1).chr + index.to_s if !name || name.size == 0
              case cell.attributes["type"]
                when "integer"
                  t.column name, :integer
                when "float"
                  t.column name, :decimal, :precision => 15, :scale => 3 
                when "text"
                  t.column name, :string, :limit=>255
                when "date"
                  t.column name, :date
                when "datetime"
                  t.column name, :datetime
                when "textarea"
                  t.column name, :text
                when "select"
                  t.column name, :text, :limit=>100
                when "check"
                  t.column name, :boolean
                else                                    #默认是整形
                  t.column name, :integer
                end
            end
          }
          t.timestamps
        end
        add_index("lmx_#{@lmx_form.code.downcase}_#{i}", :parent_id)
      end
    end
    
    @lmx_form.table = "lmx_#{@lmx_form.code.downcase}"
    @lmx_form.save
    flash[:notice] = "生成相关表成功"
    redirect_to :action=>"list", :page=>params[:page]
  end
  
  def drop_table
    @lmx_form = LmxForm.find(params[:id])
    ActiveRecord::Base.connection.drop_table("lmx_"+@lmx_form.code.downcase)
    @lmx_form.table = nil
    @lmx_form.save
    1.upto(@table.rows_count) do |i|
      ActiveRecord::Base.connection.drop_table("lmx_"+@lmx_form.code.downcase + "_#{i}") if @table.float_row?(i)
    end
    flash[:notice] = "删除相关表成功"
    redirect_to :action=>"list", :page=>params[:page]
  end
  
  def create_dynamic_form
    @lmx_form = LmxForm.find(params[:id])
    Anon.set_table_name(@lmx_form.table)
    Anon.reset_column_information
    @form = Anon.new(params[@lmx_form.code])
    @form.save
    flash[:notice] = "创建动态表成功"
    redirect_to :action=>"list", :page=>params[:page]
  end
  
  def show_dynamic_form
    @lmx_form = LmxForm.find(params[:id])
    @table = GTable.new(@lmx_form.text)
    Anon.set_table_name(@lmx_form.table)
    Anon.reset_column_information
    form = Anon.find(params[:fid])
    render :text=>@table.to_s(:style) + @table.to_s(:show, form)
  end
  
  def drag
    render :layout=>false
  end
  
  #脚本管理
  def script_manager
    @init   = @table.get_script(:init)
    @common = @table.get_script(:common)
    @calc   = @table.get_script(:calc)
    @audit  = @table.get_script(:audit)
    
    render :layout=>"popup"
  end
  
  #保存脚本
  def save_script
    for type in %w(init common calc audit)
        @table.set_script(type, params[type].to_s)
    end
    
    render :text=>"<script>window.parent.close_dialog();</script>"
  end
  
  def set_float_row
    @table.set_float_row(params[:row].to_i)
    render :partial=>"table", :locals=>{:refresh=>true}
  end
end
