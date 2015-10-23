class ChartController < ApplicationController
  def test1
    @graph = open_flash_chart_object(600,300, "/chart/line_chart?title=利润发展趋势&bars=zwh_lmx_company1_company2_company3_company4_company5_company6_company7_company8_company9_company10_company1y12_company13_company14_company15_company16&data1=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data2=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data3=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data4=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_45.0&data5=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-24.2000440277977&data6=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_27.8560134985261&data7=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data8=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data9=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data10=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data11=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data12=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data13=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data14=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data15=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data16=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data17=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&data18=0.0_0.0_0.0_0.0_0.0_0.0_0.0_0.0_-3.57486739247987&labels=a1_a2_a3_a4_a5_a6_a7_a8_a9_a10&y_title=金额", true, '/')     
  end
  
  def make_chart
    if params[:type] == "bar"
      datas = []
      1.upto(params[:bars].split("_").size) do |i|
        datas << "data#{i}=" + params["data#{i}"]
      end
      @graph = open_flash_chart_object(600,300, "/chart/bar_chart?title=#{params[:title]}&bars=#{params[:bars]}&#{datas.join('&')}&labels=#{params[:labels]}&y_title=#{params[:y_title]}", true, '/')     
    elsif params[:type] == "pie"
      @graph = open_flash_chart_object(600,300, "/chart/pie_chart?title=#{params[:title]}&data=#{params[:data]}&labels=#{params[:labels]}", true, '/')
    elsif params[:type] == "line"
      datas = []
      1.upto(params[:bars].split("_").size) do |i|
        datas << "data#{i}=" + params["data#{i}"]
      end
      @graph = open_flash_chart_object(600,300, "/chart/line_chart?title=#{params[:title]}&bars=#{params[:bars]}&#{datas.join('&')}&labels=#{params[:labels]}&y_title=#{params[:y_title]}", true, '/')
    end
    render :layout=>false
  end
 
  def bar_chart 
    begin
      colors = [['#D54C78', '#C31812'], 
      ['#5E83BF', '#5E83BF'],  
      ['#F066CC', '#F066CC'],  
      ['#639F45', '#639F45'], 
      ['#631F35', '#631F35'],
      ['#632F45', '#632F45'],
      ['#633F55', '#633F55'],
      ['#004F65', '#004F65'],
      ['#445F75', '#445F75'],
      ['#669F15', '#669F15'],
      ['#239F25', '#239F25'],
      ['#739F35', '#739F35'],
      ['#439F55', '#439F55'],
      ['#639F65', '#639F65'],
      ['#739F75', '#739F75'],
      ['#839F85', '#9933CC'],
      ['#830085', '#9900CC'],
      ['#831185', '#9911CC'],
      ['#022285', '#9922CC'],
      ['#830385', '#9933CC']]
      g = Graph.new
      g.set_bg_color('#FFFFFF')
      g.title(CGI.unescape(params[:title]), '{font-size:20px; color: #bcd6ff; margin:10px; background-color: #5E83BF; padding: 5px 15px 5px 15px;}')
      bars = params[:bars].split('_')
      
      max = -1000
      min = 0
      0.upto(bars.size-1) do |i|
        bar = BarGlass.new(55, colors[i][0], colors[i][1])
        bar.key(bars[i], 10)
        
        for data in params["data#{i+1}"].split('_')
          bar.data << data.to_i
          max = data.to_i if data.to_i > max
          min = data.to_i if data.to_i < min
        end
        g.data_sets << bar
      end
      
      g.set_y_min(min)
      g.set_y_max(max)
      
      g.set_x_labels(params["labels"].split('_'))
      g.set_x_axis_color('#909090', '#D2D2FB')
      g.set_y_axis_color('#909090', '#D2D2FB')
      g.set_x_label_style(12)
      g.set_y_label_steps(5)
      g.set_y_legend(CGI.unescape(params[:y_title]), 12, '#736AFF')
      
      render :text => g.render.to_utf8
    rescue Exception=>err
      p err
      p err.backtrace
    end
  end
  
  def pie_chart
    g = Graph.new
    g.set_bg_color('#FFFFFF')
    g.pie(60, '#505050', '{font-size: 12px; color: #404040;}')
    g.pie_values(params[:data].split("_").collect{|d| d.to_i}, params[:labels].split("_"))
    g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810 #5E83BF #F066CC #639F45 #631F35 #632F45 #633F55 #634F65 #635F75 #139F15 #239F25 #339F35 #439F55 #639F65 #739F75 #839F85))
    g.set_tool_tip("#val#%")
    g.title(CGI.unescape(params[:title]), '{font-size:18px; color: #d01f3c}' )
    render :text => g.render.to_utf8
  end
    
  def line_chart
    begin
      for tag in debase64_and_unzip(params[:p]).split("&")
        children = tag.split("=")
        params[children[0].intern] = children[1]
      end if params[:p]
      colors = [['#D54C78', '#C31812'], 
      ['#5E83BF', '#5E83BF'],  
      ['#F066CC', '#F066CC'],  
      ['#639F45', '#639F45'], 
      ['#631F35', '#631F35'],
      ['#632F45', '#632F45'],
      ['#633F55', '#633F55'],
      ['#004F65', '#004F65'],
      ['#445F75', '#445F75'],
      ['#669F15', '#669F15'],
      ['#239F25', '#239F25'],
      ['#739F35', '#739F35'],
      ['#439F55', '#439F55'],
      ['#639F65', '#639F65'],
      ['#739F75', '#739F75'],
      ['#839F85', '#9933CC'],
      ['#830085', '#9900CC'],
      ['#831185', '#9911CC'],
      ['#022285', '#9922CC'],
      ['#830385', '#9933CC']]
      
      g = Graph.new
      g.set_bg_color('#FFFFFF')
      g.title(CGI.unescape(params[:title]), '{font-size:20px; color: #bcd6ff; margin:10px; background-color: #5E83BF; padding: 5px 15px 5px 15px;}')
      bars = params[:bars].split('_')
      max = -1000
      min = 0
      p bars.size
      0.upto(bars.size-1) do |i|
          line = LineHollow.new(2,5, colors[i][0])
          line.key(bars[i], 10)
          
          for data in params["data#{i+1}"].split('_')
            line.add_data_tip(data.to_i, "")
            max = data.to_i if data.to_i > max
            min = data.to_i if data.to_i < min
          end
          g.data_sets << line
      end
  
      g.set_tool_tip('#x_label# [#val#]<br>#tip#')
      g.set_x_labels(params["labels"].split('_'))
      g.set_x_label_style(12, '#000000', 0, 2)
      
      g.set_y_min(min)
      g.set_y_max(max)
    
      g.set_y_label_steps(5)
      g.set_y_legend(CGI.unescape(params[:y_title]), 12, '#736AFF')
    rescue Exception=>err
      p err
      p err.backtrace
    end
    text = g.render
    if text.utf8?
      render :text=>text
    else
      render :text => text.to_utf8
    end
    
  end
  
  def line_chart_old
    begin
    colors = [['#D54C78', '#C31812'], 
      ['#5E83BF', '#424581'],  
      ['#F066CC', '#9933CC'],  
      ['#639F45', '#9933CC'], 
      ['#631F35', '#9933CC'],
      ['#632F45', '#9933CC'],
      ['#633F55', '#9933CC'],
      ['#634F65', '#9933CC'],
      ['#635F75', '#9933CC'],
      ['#139F15', '#9933CC'],
      ['#239F25', '#9933CC'],
      ['#339F35', '#9933CC'],
      ['#439F55', '#9933CC'],
      ['#639F65', '#9933CC'],
      ['#739F75', '#9933CC'],
      ['#839F85', '#9933CC'],
      ['#830085', '#9900CC'],
      ['#831185', '#9911CC'],
      ['#832285', '#9922CC'],
      ['#833385', '#9933CC']]
      
    g = Graph.new
    g.set_bg_color('#FFFFFF')
    g.title(CGI.unescape(params[:title]), '{font-size:20px; color: #bcd6ff; margin:10px; background-color: #5E83BF; padding: 5px 15px 5px 15px;}')
    
    bars = params[:bars].split('_')
    max = -1000
    min = 0
    p bars.size
    0.upto(bars.size-1) do |i|
        line = LineHollow.new(2,5, colors[i][0])
        line.key(bars[i], 10)
        
        for data in params["data#{i+1}"].split('_')
          line.add_data_tip(data.to_i, "")
          max = data.to_i if data.to_i > max
          min = data.to_i if data.to_i < min
        end
        g.data_sets << line
    end
  
    g.set_tool_tip('#x_label# [#val#]<br>#tip#')
    g.set_x_labels(params["labels"].split('_'))
    g.set_x_label_style(12, '#000000', 0, 2)
    
    g.set_y_min(min)
    g.set_y_max(max)
  
    g.set_y_label_steps(5)
    g.set_y_legend(CGI.unescape(params[:y_title]), 12, '#736AFF')
    
    rescue Exception=>err
      p err
      p err.backtrace
    end
    render :text => g.render.to_utf8
  end
end
