class MapiaApiEvent
# События
#	На любом экземпляре класса Mapia можно подписываться на события. 
#	В обработчик события будет передан аргумент event в котором поле target - это экземпляр класса Mapia, 
#	и type - произошедшее событие. Остальные поля в зависят от произошедшего события.
#
# Пример использования событий
#	 mapia.addEventListener('mapClick', function(event){
#  	event.target.addMarker((i++).toString(), event.loc, {title:i.toString(), icon_url:'http://example.com/icons/'+i.toString()+'.png'})
#		});

  include ActionView::Helpers::JavaScriptHelper
  
#  Происходит, когда флеш-объект Mapia создан, загружен, и готов выполнять команды от Mapia API. 
#  Все методы экземпляра класса Mapia, вызваные до этого события, складываются в очередь, 
#  и выполняются непосредственно перед этим событием.
  INITIALIZED = 'initialized'
  
# Происходит когда изменено значение zoom. 
# Параметр event содержит дополнительное поле zoom
  ZOOM_CHANGED = 'zoomChanged'
  
# Происходит когда изменен центр карты. 
# Параметр event содержит дополнительное поле center
  CENTER_CHANGED = 'centerChanged'

# Происходит когда пользователь кликает мышкой по карте. 
# Параметр event содержит дополнительное поле loc - точка на карте в которую кликнул пользователь  
  MAP_CLICK = 'mapClick'
  
#  Происходит когда пользователь кликает на маркере. Параметр event содержит дополнительные поля:
#    * markerId - идентификатор маркера
#    * loc - долгота и широта маркера (lat, lon)
#    * popupData - даные для попапа маркера
  MARKER_CLICK = 'markerClick'
  
# Когда в методах setCenter и addMarker используется строка вместо LatLon объекта, 
# то для этой строки будет отправлен на сервер поисковый запрос. 
# Если адрес найден, то произойдет geocodeSuccess, 
# в противном случае - geocodeFailure.
  GEOCODE_SUCCESS = 'geocodeSuccess'
  GEOCODE_FAILURE = 'geocodeFailure'
  
  attr_accessor :type,
  							:function,
                :map,
                :options
                
  def initialize(type, options = {})
    @options = options.symbolize_keys!
    @map = @options.delete(:map)
    @function = @options.delete(:function)
    @type = type
    
    if @type.blank? || !@map || !@map.kind_of?(MapiaApi)
      raise "Must set position and map for MapiaApi."
    end
  end
  
  def to_js
    js = []
    
    js << "#{@map.element_id}.addEventListener('#{@type}', function(event){"
    js << "#{function}"
    js << "});"
    
    return js.join("\n")
  end
	
	def js_options
		js = []
		
		@options.each do |k, v|
			next if v.nil?
			js << (v.is_a?(String) ? "#{k}: '#{v}'" : "#{k}: #{v}")
		end
				
		",{#{js.join(',')}}" unless js.empty?
	end
end
