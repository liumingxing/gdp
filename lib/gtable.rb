require 'rexml/document'

class GTable 
  attr_reader :code, :name
  
  #初始化一个表格
  #接受两种初始化方法 GTable.new(xml), GTable.new(code, name, rows, cols)
  #xml  : 表格xml文本
  #code : 表格代码
  #name : 表格名称
  #rows : 行数
  #cols : 列数
  def initialize(*args)
    if args.size == 1                       #从xml初始化
      @doc = REXML::Document.new(args[0])
      @e_table = REXML::XPath.first(@doc, "/tables/table")
      @code = @e_table.attributes["code"]
      @name = @e_table.attributes["name"]
      
      @column_count = REXML::XPath.match(@doc, "/tables/table/col").size
    elsif args.size == 4
      @code = args[0]
      @name = args[1]
      rows = args[2]
      cols = args[3]
    
      @doc = REXML::Document.new("<tables><styles/></tables>")
      e_styles = REXML::XPath.first(@doc, "/tables/styles")
      e_style = e_styles.add_element "style", {"id"=>"s1", "font"=>"13px 宋体", "color"=>"black", "background-color"=>"white", "text-align"=>"left", "vertical-align"=>"middle", "border-top"=>"1px solid black", "border-right"=>"1px solid black", "border-bottom"=>"1px solid black", "border-left"=>"1px solid black", "word-wrap"=>"break-word"}
      
      @e_table = REXML::XPath.first(@doc, "tables").add_element "table", {"class"=>'lmx_table', "style"=>'border-collapse:collapse'}
      @e_table.attributes["code"] = @code
      @e_table.attributes["name"] = @name
      @e_table.attributes["style"] = "border: 0px solid black;border-collapse:collapse;table-layout: fixed;"
      rows = 10 if rows > 50 || rows < 0
      cols = 10 if cols > 50 || cols < 0
      1.upto(cols) do |col|
        @e_table.add_element "col", {"width"=>"100px"}
      end
      
      1.upto(rows) do |row|
        e_tr = @e_table.add_element "tr", {"height"=>"30px"}
        1.upto(cols) do |col|
          e_tr.add_element "td", {"class"=>"s1"}
        end
      end
      
      @column_count = cols
    end
    
    #预先解析，加快速度
    parse_styles()
    parse_rows()
    
    @rows = REXML::XPath.match(@doc, "/tables/table/tr")            #预先读出tr，放在内存中，提高效率
  end  
  
  #设置表编码
  def code=(c)
    @code = c
    @e_table.attributes["code"] = @code
  end
  
  #设置表名称
  def name=(n)
    @name = n
    @e_table.attributes["name"] = @name
  end
  
  #行数
  def rows_count
    @rows.size
  end
  
  #列数
  def cols_count
    @column_count
  end
  
  #从1开始计数
  def get_cell_attribute(row, col, attr)
    row = self[row]
    e_td = row.elements[col]
    if attr == "text"                                                              #文本
          e_td.text.to_s.strip.gsub(" ", "").gsub("\n", "")
    elsif %w(name store title notnull readonly type data thousand dot desc width checkwidth prefix postfix style).include?(attr)   #属性
          e_td.attributes[attr]
    else                                                                          #风格
          style = get_style(e_td.attributes["class"])
          style.attributes[attr] 
    end
  end
  
  #设置单元格属性
  #x,y均从1开始计数
  #table_index : 第几张表，从1开始计数
  #单元格属性 name store type thousand dot desc width checkwidth含义分别为
  #名称 存储到数据库 标题 必填 只读 输入类型（number text date select check）选择项（不准带单引号） 千分位 小数位 单元格描述 宽度 等宽检查 前置字符串 后置字符串
  #
  def set_cell_attribute(row1, col1, row2, col2, attr, value)
    row1.upto(row2) do |row|
      e_tr = self[row]
      col1.upto(col2) do |col|
        e_td = e_tr.elements[col]
        if attr == "text"                                                              #文本
          e_td.text = value.to_s.gsub(" ", "　")                                        #将英文空格改成中文空格
        elsif %w(name store title notnull readonly type data thousand dot desc width checkwidth prefix postfix).include?(attr)   #属性
          e_td.attributes[attr] = value
        else                                                                          #风格
          set_cell_style(e_td, attr, value)
        end
      end
    end
  end
  
  #插入行
  #index为从1开始计数
  def insert_row(index, before=true)
    old_tr = self[index]
    e_tr = @e_table.add_element "tr", {"height"=>"30px"}
    col_size = REXML::XPath.match(@doc, "/tables/table/col").size
    1.upto(col_size) do |col|
        e_tr.add_element "td", {"class"=>"s1"}
    end
    if before
      @e_table.insert_before(old_tr, e_tr)
    else
      @e_table.insert_after(old_tr, e_tr)
    end
    parse_rows()
  end
  
  #删除行
  def delete_row(index)
    e_tr = self[index]
    @e_table.delete(e_tr)
    parse_rows()
  end
  
  #设置行高,从1计数
  def set_row_height(index, height)
    self[index].attributes["height"] = height
  end
  
  #获得行高,index从1开始计数
  def row_height(index)
    self[index].attributes["height"]
  end
  
  #插入列
  def insert_col(index, before=true)
    old_col  = REXML::XPath.match(@doc, "/tables/table/col")[index]
    e_col = @e_table.add_element "col", {"width"=>"90px"}
    if before
      @e_table.insert_before(old_col, e_col)
    else
      @e_table.insert_after(old_col, e_col)
    end
    
    rows{|row, row_index|
      old_cell = row.children[index-1]
      e_td = row.add_element "td", {"class"=>"s1"}
      if before
        row.insert_before(old_cell, e_td)
      else
        row.insert_after(old_cell, e_td)
      end
    }
    
    @column_count = REXML::XPath.match(@doc, "/tables/table/col").size
  end
  
  #删除列, 从1开始计数
  def delete_col(index)
    old_col  = REXML::XPath.match(@doc, "/tables/table/col")[index-1]
    @e_table.delete(old_col)
    
    rows{|row, row_index|
      e_cell = row.elements[index]
      row.delete(e_cell) 
    }
    
    @column_count = REXML::XPath.match(@doc, "/tables/table/col").size
  end
  
  #设置列宽
  def set_col_width(index, width)
    e_col  = REXML::XPath.match(@doc, "/tables/table/col")[index-1]
    e_col.attributes["width"] = width
  end
  
  #获得列宽,index从1开始计数
  def col_width(index)
    e_col  = REXML::XPath.match(@doc, "/tables/table/col")[index-1]
    e_col.attributes["width"]
  end
  
  #合并,从1开始计数
  def merge(row1, col1, row2, col2)
    cells{|cell, row_index, col_index|
      if row_index == row1 && col_index == col1
        cell.attributes["colspan"] = col2 - col1 + 1
        cell.attributes["rowspan"] = row2 - row1 + 1
      elsif row_index >= row1 && row_index <= row2 && col_index >= col1 && col_index <= col2
        cell.attributes["style"] = "display:none"
      end
      
      return if row_index > row2 && col_index > col2
    }
  end
  
  #拆分某单元格
  def split(row, col)
    rowspan = 1
    colspan = 1
    cells{|cell, row_index, col_index|
      if row_index == row && col_index == col
        rowspan = cell.attributes["rowspan"].to_i
        colspan = cell.attributes["colspan"].to_i
        cell.delete_attribute("colspan")
        cell.delete_attribute("rowspan")
      elsif row_index >= row && col_index >= col && row_index <=row+rowspan && col_index <= col + colspan 
        cell.delete_attribute("style")
      end
      
      return if row_index > row + rowspan && col_index > col + colspan
    }
  end
  
  #压缩风格，去除垃圾style
  def pack()
    style_ids = REXML::XPath.match(@doc, "/tables/styles/style").collect{|style|
      style.attributes["id"]
    }
    for td in REXML::XPath.match(@e_table, "tr/td")
      style_ids.delete(td.attributes["class"])
    end
    e_styles = REXML::XPath.first(@doc, "/tables/styles")
    for id in style_ids
      e_styles.delete( REXML::XPath.first(e_styles, "style[@id='#{id}']") )
    end
  end

  #输出字符串
  # xml ：xml格式字符串
  # style ：风格，适用于html
  # show  ：只读html
  # edit  ：可编辑的html页面
  # design : 设计界面
  # script : 脚本
  def to_s(t, record=nil)
    str = ''
    formatter = REXML::Formatters::Pretty.new
    if t.to_s == "xml"                                                   #输出原始xml,REXML有缺陷，为保住脚本中的空白字符，绕弯进行格式化
      default = REXML::Formatters::Default.new
      str = "<tables>\n" + " "*2
      t = ''
      default.write(REXML::XPath.first(@doc, "/tables/styles"), t)
      str += t + "\n  " + to_s(:design) + "\n  "
      for script in REXML::XPath.match(@doc, "/tables/script")
        t = ''
        default.write(script, t)
        str += t
      end
      str += "\n</tables>"
    elsif t.to_s == "style"                                               #输出风格
      str = style_str()
    elsif t.to_s == "design"                                              #输出设计界面
      formatter.write(@e_table, str)
    elsif t.to_s == "show"                                                #输出只读界面
      set_record(record) 
      formatter.write(@e_table, str)
    elsif t.to_s == "edit"                                                #输出可编辑界面
      set_record(record, false)
      make_input
      formatter.write(@e_table, str) 
      str += to_s(:script)
    elsif t.to_s == "script"                                              #输出脚本
      str = "<script>\n"
      str += get_script(:common)                                          #公共脚本
      str += "\n $('.lmx_table input').bind('change', calc)\n"
      str += "function calc(){ #{get_script(:calc)} } \n"
      str += "$('form').submit(audit)\n"
      str += "function audit(){ #{get_script(:audit)} } \n"
      str += "\n</script>"
    else
      str = "not implemented!"
    end
    str
  end
  
  #遍历所有行
  #调用方式为 table.rows{|row, index|}
  def rows(&block)
    1.upto(@rows.size) do |index|
      yield(@rows[index-1], index)
    end
  end
  
  #遍历所有单元格，包括被合并掉的以及不填写到数据库中的
  #调用方式为 table.cells{|cell, row_index, col_index| }
  def cells(&block)
    cols = REXML::XPath.match(@doc, "/tables/table/col")
    1.upto(@rows.size) do |row|
      1.upto(cols.size) do |col|
        yield(self[row].elements[col], row, col)
      end
    end
  end
  
  #遍历所有需要填写的单元格
  #调用方式为 table.cells{|cell, row_index, col_index| }
  def input_cells(&block)
    1.upto(@rows.size) do |row|
      1.upto(@column_count) do |col|
        cell = self[row].elements[col]
        next if cell.attributes["store"] == "false"                       #不存储到数据库中
        next if cell.attributes["style"] == "display:none"                #被合并了
        yield(cell, row, col)
      end
    end
  end
  
  #返回单元格的数据库名称
  def db_name(cell, row_index, col_index)
    name = cell.attributes["name"]
    name = ('A'[0]+col_index-1).chr + row_index.to_s if !name || name.size == 0
    name
  end
  
  #设置js脚本
  #type有三种值 'common' 'calc' 'audit'
  def set_script(type, script)
    s_element = REXML::XPath.first(@doc, "/tables/script[@type='#{type.to_s}']")
    s_element = @doc.root.add_element 'script', {"type"=>type.to_s} if !s_element
    s_element.text = script
  end
  
  #获得js脚本
  def get_script(type)
    s_element = REXML::XPath.first(@doc, "/tables/script[@type='#{type.to_s}']")
    return s_element.text.to_s.strip if s_element
    return ''
  end
  
#似有函数
private
  #返回某行，从1开始计数
  def [](index)
    @rows[index-1]
  end
  
  #解析style到内存中
  def parse_styles
    @styles = REXML::XPath.match(@doc, "/tables/styles/style")
  end
  
  #解析tr到内存中
  def parse_rows
    @rows = REXML::XPath.match(@doc, "/tables/table/tr")
  end
  
  #新增一个风格后新的id
  def get_new_style_id
    e_style = REXML::XPath.match(@doc, "/tables/styles/style").last
    id = e_style.attributes["id"]
    index = id[1, id.size-1 ].to_i + 1
    "s" + index.to_s
  end
  
  def get_style( id )
    for element in @styles
      return element if element.attributes["id"] == id
    end
    return nil
  end
  
  #设置某单元格的风格
  #风格有font color background-color align valign border border-color word-wrap(默认为break-word )
  def set_cell_style(e_td, attr, value)
    new_style = REXML::Element.new 'style'
    new_style.attributes["id"] = get_new_style_id()
    old_style = REXML::XPath.first(@doc, "/tables/styles/style[@id='#{e_td.attributes['class']}']")
    #复制所有属性
    old_style.attributes.each{|key, value1|
      next if key == "id"
      new_style.attributes[key] = value1
    }
    new_style.attributes[attr] = value
    
    #查找是否拥有相同的风格，有则退出，无则加上
    for style in REXML::XPath.match(@doc, "/tables/styles/style")
      same = style.attributes.size == new_style.attributes.size
      style.attributes.each{|key, value1|
        next if key == "id"
        same = false if new_style.attributes[key] != value1
      }
      if same
        e_td.attributes["class"] = style.attributes["id"]
        return 
      end
    end
    
    #添加新风格节点
    REXML::XPath.first(@doc, "/tables/styles").add_element new_style
    e_td.attributes["class"] = new_style.attributes["id"]
    parse_styles
  end
  
  def style_str
    str = "<style>\n"
    for style in REXML::XPath.match(@doc, "/tables/styles/style")
      str += "\n.#{style.attributes['id']} {"
      style.attributes.each{|key, value|
        next if key == "id"
        str += "#{key}: #{value};  "
      }
      str += "}"
    end
    str += "\n</style>\n"
  end
  
  #设置record数据
  #主要用户已经从数据库中取得了数据，赋值到表单中
  #record为ActiveRecord::Base实例
  def set_record(record, with_format=true)
    return if !record
    input_cells{|cell, row_index, col_index|
      name = db_name(cell, row_index, col_index)
      
      case cell.attributes["type"]
      when "datetime"
        cell.text = record[name].to_s(:db) if record[name]
      when "check"
        cell.text = {true=>'是', false=>'否', nil=>'否'}[record[name]]
      when "float"
        if with_format                                          #格式化
          if cell.attributes["thousand"] == "true"              #千分位
            cell.text = number_with_delimiter(number_with_precision(record[name], :precision=>cell.attributes["dot"].to_i))
          else
            cell.text = number_with_precision(record[name], :precision=>cell.attributes["dot"].to_i)
          end
        else                                                    #不格式化
          cell.text = record[name].to_s
        end
      when "integer"
        if with_format
          cell.text = number_with_delimiter(record[name]) 
        else
          cell.text = record[name].to_s
        end
      else
        cell.text = record[name].to_s
      end
      
      if with_format
         if cell.attributes["prefix"]
            cell.text = cell.attributes["prefix"] + cell.text.to_s
         end
         
         if cell.attributes["postfix"]
          cell.text = cell.text + cell.attributes["postfix"]
         end
      end
    }
  end
  
  #自动创建输入控件
  def make_input
      input_cells{|cell, row_index, col_index|
        next if cell.attributes["readonly"] == "true"     #只读不处理

        text = cell.text.to_s.strip
        cell.text = ''
        name = db_name(cell, row_index, col_index)
        
        input = nil
        case cell.attributes["type"].to_s
        when ""     #默认是整型
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"text", "value"=>text, "name"=>"#{@code}[#{name}]"}
        when "integer"
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"text", "value"=>text, "name"=>"#{@code}[#{name}]"}
        when "float"
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"text", "value"=>text, "name"=>"#{@code}[#{name}]"}
        when "text"
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"text", "value"=>text, "name"=>"#{@code}[#{name}]"}
        when "textarea"
          input = cell.add_element "textarea", {"style"=>"width:98%; height:98%;", "name"=>"#{@code}[#{name}]"}
          input.text = text
        when "date"
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"text", "onfocus"=>"WdatePicker({})", "value"=>text, "name"=>"#{@code}[#{name}]"}
        when "datetime"
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"text", "value"=>text, "onfocus"=>"WdatePicker({dateFmt:\"yyyy-MM-dd HH:mm:ss\"})", "name"=>"#{@code}[#{name}]"}
        when "select"
          input = cell.add_element "select", {"name"=>"#{@code}[#{name}]"}
          begin
            if cell.attributes["data"]
              for option in instance_eval(cell.attributes["data"])
                o = input.add_element "option", {"value"=>option[1]}
                o.text = option[0]
                o.attributes["selected"] = "selected" if option[1] == text
              end 
            end
          rescue Exception=>err
            p err
            p err.backtrace
          end
        when "check"
          input = cell.add_element "input", {"type"=>"checkbox", "name"=>"#{@code}[#{name}]", "value"=>"1"}
          input.attributes["checked"] = "checked" if text == "是"
        when "button"
          input = cell.add_element "input", {"style"=>"width:98%", "type"=>"button", "class"=>"button", "value"=>text, "name"=>"#{@code}[#{name}]"}
        end
        
        if cell.attributes["prefix"] && cell.attributes["prefix"].size > 0    #加入前置字符串
          input.attributes["style"] = "width:50%" if input.attributes["type"] != "checkbox"
          span = cell.add_element "span"
          span.text = cell.attributes["prefix"]
          cell.insert_before(input, span)
        end
        
        if cell.attributes["postfix"] && cell.attributes["postfix"].size > 0    #加入后置字符串
          input.attributes["style"] = "width:50%" if input.attributes["type"] != "checkbox"
          span = cell.add_element "span"
          span.text = cell.attributes["postfix"]
        end
        
        #公共部分
        input.attributes["title"] = cell.attributes["title"]
        input.attributes["validate"] = "required:true;" if cell.attributes["notnull"] == "true"
        input.attributes["validate"] = input.attributes["validate"].to_s +  "number:true;" if cell.attributes["type"] == "integer" || cell.attributes["type"] == "float" || !cell.attributes["type"]
        input.attributes["validate"] = input.attributes["validate"].chop if input.attributes["validate"] && input.attributes["validate"].size > 0
      }
  end
end



#table.set_cell_attribute(1, 1, 2, 2, "border-top", "2px solid red")
#
##table = GTable.new("aa", "bb", 4, 4)
#table.set_cell_attribute(1, 1, 2, 1, "text", "你好啊")
#table.set_cell_attribute(1, 1, 2, 1, "type", "number")
#table.set_cell_attribute(1, 1, 1, 1, "font", "italic bold 30px 隶书")
#table.set_cell_attribute(2, 2, 3, 3, "background-color", "red")
#table.insert_row(3)
#table.insert_row(3)
#table.delete_row(3)
#table.set_row_height(2, "80px")
#table.set_cell_attribute(1, 4, 4, 4, "border-left", "2px solid blue")
#table.set_cell_attribute(1, 4, 4, 4, "border-right", "2px solid blue")
#table.set_cell_attribute(1, 4, 4, 4, "border-top", "2px solid blue")
#table.set_cell_attribute(1, 4, 4, 4, "border-bottom", "2px solid blue")
#table.set_cell_attribute(1, 1, 1, 1, "color", "green")
#table.set_cell_attribute(1, 1, 1, 1, "text-align", "right")
#table.insert_col(2)
#table.insert_col(2)
#table.delete_col(2)
#table.set_col_width(2, "150px")
#table.merge(2, 2, 3, 3)
#table.merge(4, 5, 5, 5)
#table.split(4, 5)
#table.set_cell_attribute(2, 2, 2, 2, "background-image", "url('1.gif')")
#puts table.get_cell_attribute(2, 2, "text")
#puts table.get_cell_attribute(2, 2, "background-image")
#puts table.get_cell_attribute(3, 2, "title")
#table.code = 'lmx'
#
##puts table.to_s(:xml)
##puts table.to_s(:style)
##puts table.to_s(:edit)
##puts table.to_s(:show)
#
#file = File.new('d:\test.html', 'w')
#file << table.to_s(:style) << table.to_s(:design)
#file.close