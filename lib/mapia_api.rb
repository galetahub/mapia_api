# MapiaApi
class MapiaApi
  include UnbackedDomId
  attr_accessor :element_id,
    :markers,
    :overlays,
    :zoom,
    :center,
    :lang,
    :wmode
  
#  MapiaApi.new(options)
#
#	elementId - DomID элемента, который будет заменен на Flash-объект. Флеш-объекту будут установлины заначения with и height 100%, это значит что размер и позиция карты задается размером и позицией контейнера в котором находиться elementId. Пример
#	options - параметр типа Object с такими аттрибутами:
#
#    * zoom - начальный уровень приближения карты. Число от 6(далеко) до 18(близко)
#    * center - точка в которую будет цетрирована карта. Это может быть либо объект с аттрибутами lat, lon - где lat и lon - это широта и долгота соответственно; либо строка c почтовым адресом.
#    * lang - язык на котором будут отображаться названия на карте (доступные варианты "ru" и "ua")
#    * wmode - параметр wmode будет установлен флеш объекту при вставлении в документ
 
  def initialize(options = {})
    self.element_id = 'mapia'
    self.markers = []
    self.overlays = []
  
    options.each_pair { |key, value| send("#{key}=", value) }
  end
  
  def to_html
    html = []
    
    html << "<script src=\"http://mapia.ua/api/0.9.0/mapiaapi.js?apikey=#{MAPIA_APPLICATION_KEY}\" type=\"text/javascript\"></script>"
    html << "<script type=\"text/javascript\">\n/* <![CDATA[ */\n"
    html << to_js
    html << "/* ]]> */</script> "
    
    return html.join("\n")
  end
 
  def to_enable_prefix true_or_false
    true_or_false ? "enable" : "disable"
  end
  
  def to_js
    js = []
    
    # Initialise the map variable so that it can externally accessed.
    js << "var #{element_id};"
    markers.each { |marker| js << "var #{marker.element_id};" }
    
    js << center_map_js
    
    js << "window.onload = function(){"
    js << "#{element_id} = new Mapia('#{element_id}'#{options_js});"
    js << "center_#{element_id}();"
        
    # Put all the markers on the map.
    markers.each do |marker| 
      js << ' ' + marker.to_js
      js << ''
    end
    
    js << "}"
    
    return js.join("\n")
  end
  
  def options_js
  	js = []
  	
  	js << "lang: '#{self.lang}'" if self.lang
  	js << "wmode: '#{self.wmode}'" if self.wmode
  	
  	",{#{js.join(',')}}" unless js.empty?
  end
  
  def markers_icons_js
    icons = []
    
    for marker in markers
      if marker.icon and !icons.include?(marker.icon)
        icons << marker.icon
      end
    end
    
    js = []
    
    for icon in icons
      js << icon.to_js
    end
    
    return js.join("\n")
  end
    
  def center_map_js
    set_center_js = []
    
    set_center_js << "#{element_id}.setZoom(#{self.zoom});" if self.zoom
    set_center_js << "#{element_id}.setCenter(#{center_js});" if self.center
    
    "function center_#{element_id}() {\n #{set_center_js.join "\n"}\n}"
  end
  
  def center_js
  	return "{lat:#{self.center[:lat]}, lon:#{self.center[:lat]}}" if self.center.is_a?(Hash)
  	return "{lat:#{self.center[0]}, lon:#{self.center[1]}}" if self.center.is_a?(Array)
  	"'#{self.center}'"
  end
  
  def center_on_bounds_js
    return "center_#{element_id}();"
  end
  
  def div(width = '100%', height = '100%')
    "<div id='#{element_id}' style='width: #{width}; height: #{height}'></div>"
  end
end
