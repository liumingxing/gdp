class Time 
 def diff(include_seconds = false)
    from_time = self
    to_time = Time.new
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
    when 0..1
      return (distance_in_minutes == 0) ? '不到1分钟前' : '1分钟前' unless include_seconds
      case distance_in_seconds
      when 0..4   then '不到5秒前'
      when 5..9   then '不到10秒前'
      when 10..19 then '不到20秒前'
      when 20..39 then '半分钟前'
      when 40..59 then '不到1分钟前'
      else             '1分钟前'
      end

    when 2..44           then "#{distance_in_minutes}分钟前"
    when 45..89          then '1小时前'
    when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round}小时前"
    when 1440..2879      then '1天前'
    when 2880..43199     then "#{(distance_in_minutes / 1440).round}天前"
    when 43200..86399    then '1个月前'
    when 86400..525959   then "#{(distance_in_minutes / 43200).round}个月前"
    when 525960..1051919 then '1年前'
    else                      "over #{(distance_in_minutes / 525960).round}年前"
    end
  end
end