# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def path(text)
    "<script>set_path('#{text}')</script>"
  end
  
  def right_text(text)
    "<script>add_right_text('#{text}')</script>"
  end
  
  def money(number)
    number_with_delimiter(number_with_precision(number, :precision => 2))
  end

  def color_row(id=nil, option={})
    @index = @index || 0
    @index += 1
    result = ""
    id = 1 if !id

    options = ""
    option.each { |key,value|
      next if key == :onclick
      options += " #{key.to_s} = #{value.to_s} "
    } if option

    if @index % 2 == 1
      result = "<tr class='TrLight' id='#{id}' onmouseover='tr_mouseover(this)'  onmouseout='tr_mouseout(this)' onClick='tr_click(this);#{option[:onclick]}' #{options}> "
    else
      result = "<tr  class = 'TrDark' id='#{id}' onmouseover='tr_mouseover(this)'  onmouseout='tr_mouseout(this)' onClick='tr_click(this);#{option[:onclick]}' #{options}> "
    end
    result
  end

  def round_table(width, title, &block)
    content = capture(&block)
    right_text = ""
    if title.is_a?(Array)
      right_text = title[1]
      title = title[0]
    end
    concat %!
      <table width="#{width}"  border="0"  cellspacing="0" cellpadding="0">
	<tr height=1 >
		<td colspan=2 width=2></td><td style="background:#666666" width=98%></td><td colspan=2 width=2></td>	
	</tr>
	<tr height=1 >
		<td width=1></td>
		<td width=1 style="background:#666666"></td>
		<td style="background:#999999" width=99%></td>
		<td width=1 style="background:#666666"></td>
		<td width=1></td>
	</tr>
	<tr height=1 style="background:black">
		<td width=1 style="background:#666666"></td>
		<td colspan=3 style="background:#999999" width=99%></td>
		<td width=1 style="background:#666666"></td>
	</tr>
	<tr height=15>
		<td width=1 style="background:#666666"></td>
		<td colspan=3 style="background:#999999;color:white" >
                <table width=100%>
                    <tr>
                       <td align='left'><b>&nbsp;#{title}</b></td>
                       <td align='right'>#{right_text}&nbsp;</td>
                       <td align='right'><a href="#" onclick="close_round(this)"><img src="/img/i_jt1.gif" border="0" /></a></td>
                    </tr>
                </table>
                </td>
		<td width=1 style="background:#666666"></td>
	</tr>
	<tr height=10>
		<td width=1 style="background:#666666"></td>
		<td width=1 style="background:#999999"></td>
		<td style="background:#999999"><div style="display:block">#{content}</div></td>
		<td width=1 style="background:#999999"></td>
		<td width=1 style="background:#666666"></td>
	</tr>
	<tr height=1 style="background:black">
		<td width=1 style="background:#666666"></td>
		<td colspan=3 style="background:#999999" width=99%></td>
		<td width=1 style="background:#666666"></td>
	</tr>
	<tr height=1 >
		<td width=1></td>
		<td width=1 style="background:#666666"></td>
		<td style="background:#999999" width=99%></td>
		<td width=1 style="background:#666666"></td>
		<td width=1></td>
	</tr>
	<tr height=1 >
		<td colspan=2 width=2></td><td style="background:#666666" width=98%></td><td colspan=2 width=2></td>	
	</tr>
</table>
    !, block.binding
  end
  
  def show_tree(roots)
    result = '<script>'
    for d in roots
      result << "var tree#{d.id} = new WebFXTree('#{d.id.to_s + ":" + d.name}');\n"
      result << "tree#{d.id}.icon = '/img/foldericon.png';\n"
      result << "tree#{d.id}.openIcon = '/img/openfoldericon.png';\n"
      result << show_subnode(d)
      result << "document.write(tree#{d.id});tree#{d.id}.expandAll();\n"
    end
    result += "</script>"
    return result
  end
  
  def show_subnode(node)
    result = ''
    for child in node.children
      result << "tree#{child.id} = tree#{node.id}.add(new WebFXTreeItem('#{node.id.to_s + ":" + child.name}'));\n"
      result << "tree#{child.id}.openIcon = '/img/new.png';"
      result << "tree#{child.id}.icon = '/img/new.png';"
      result << show_subnode(child)
    end
    
    result 
  end
  
  def show_checked_tree(roots)
    result = '<script>'
    for d in roots
      result << "var tree#{d.id} = new WebFXCheckBoxTree('#{d.name}', false, #{d.id});\n"
      result << "tree#{d.id}.icon = '/img/foldericon.png';\n"
      result << "tree#{d.id}.openIcon = '/img/openfoldericon.png';\n"
      result << show_checked_subnode(d)
      result << "document.write(tree#{d.id});tree#{d.id}.expandAll();\n"
    end
    result += "</script>"
    return result
  end
  
  def show_checked_subnode(node)
    result = ''
    for child in node.children
      result << "tree#{child.id} = tree#{node.id}.add(new WebFXCheckBoxTreeItem('#{child.name}', false, #{node.id}));\n"
      result << "tree#{child.id}.openIcon = '/img/new.png';"
      result << "tree#{child.id}.icon = '/img/new.png';"
      result << show_checked_subnode(child)
    end
    
    result 
  end


include ActionView::Helpers::FormHelper
module ActionView::Helpers::FormOptionsHelper
  def select_province_and_city(object, province, city, options = {}, html_options = {})
    province_name = instance_eval("@#{object}.#{province}")
    city_name = instance_eval("@#{object}.#{city}")
    p_name = "#{object}[#{province}]"
    p_id = "#{object}_#{province}"
    c_name = "#{object}[#{city}]"
    c_id = "#{object}_#{city}"

    ajax_str = "$.ajax({async:true, success:function(request){$('##{c_id}').replaceWith(request);}, url:'/main/city_of?id=' + $('##{p_id}').val() +'&did=#{c_id}&name=#{c_name}'})"
    result = "<select id=#{p_id} name=#{p_name} onchange=\" #{ajax_str}\">"
    result = "<select id=#{p_id} name=#{p_name} onchange=\" #{ajax_str}\" validate='required:true' title='省份'>" if options[:required]
    result << "<option>--请选择--</option>"
    for area in Area.provinces
      selected = ""
      selected = "selected" if area.text == province_name
      result << "<option value='#{area.text}' #{selected}>#{area.text}</option>"
    end
    result << "</select>"
    if options[:required]
      result << "<select id=#{c_id} name=#{c_name} validate='required:true' title='城市'>"
    else
      result << "<select id=#{c_id} name=#{c_name}>"
    end
    result << "<option>--请选择--</option>"
    for area in Area.citys_of(province_name)
      selected = ""
      selected = "selected" if area.text == city_name
      result << "<option value='#{area.text}' #{selected}>#{area.text}</option>"
    end
    result << "</select>"
  end
end

end
