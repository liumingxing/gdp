module LmxFormHelper
  def bool_str(str)
    if str == "false"
      "否"
    elsif str == "true"
      "是"
    else
      ""
    end
  end
  
  
  def type_str(str)
    alltypes = [['integer', '整型'], ['float', '浮点'],  ['text', '文本'], ['textarea', '大文本'], ['date', '日期'], ['datetime', '时间'], ['select', '下拉选择'], ['check', '复选框'], ['button', '按钮']]
    for t in alltypes
      return t[1] if str == t[0]
    end
    ''
  end
  
  def align_str(str)
    alltypes = [['left', '左'], ['center', '中'], ['right', '右'], ['top', '上'], ['middle', '中'], ['bottom', '下']]
    for t in alltypes
      return t[1] if str == t[0]
    end
    ''
  end
end
