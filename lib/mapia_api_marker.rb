class MapiaApiMarker
# addMarker(markerId, latlonOrString, popupData)
# Устанавливает маркер с идентификатором markerId в место у казаное координатами или адресом во втором параметре. Если такой идентификатор уже был использован другим маркером, маркер не добавится. Объект popupData содерит данные, которые должен отображать попап, может содержать следующие аттрибуты:
#
#    * title - заголовок. Отображается в подсказке при наведении на маркер. (Обязательное поле)
#    * icon_url - url иконки маркера. Если иконка находится не на mapia.ua, то адресс должен быть указан полностью, и на сервере с которого загружается иконка, должен быть файл /crossdomain.xml, разрешающий доступ домену mapia.ua (Обязательное поле)
#    * nopopup - true|false. Установите true если не хотите чтоб отображался попап при клике на маркер.
#    * custom_content - url *.swf файла, который является Flex-модулем, который будет подгружен и отображен в попапе. Если не указан, то будет использован стандартный модуль. Подробнее о создании модулей содеримого попапа ниже.
#
# Все остальные поля будут переданы в модуль, отображающий содержимое попапа. Для стандартного модуля можно передавать такие поля:
#
#    * title - Отображается большими буквами.
#    * category_name - Отображается в попапе над заголовком.
#    * logo - url логотипа, картинка 100x100.
#    * address - адрес.
#    * phone - телефон.
#    * url - адрес веб-сайта. Протокол в url должен быть указан обязательно. Например: http://example.com
#    * note - текст, который отображается в попапе под адресом, телефоном, е-мейлом.
#    * description - текст в попапе.

  include ActionView::Helpers::JavaScriptHelper
  
  attr_accessor :element_id,
                :position,
                :map,
                :options
                
  def initialize(position, options = {})
    @options = options.symbolize_keys!
    
    @map = @options.delete(:map)
    @position = position
    if !@map || !@map.kind_of?(MapiaApi)
      raise "Must set map for MapiaApi."
    end
    @element_id = @options.delete(:element_id) || "#{@map.element_id}_marker_#{@map.markers.size + 1}"
    @options[:icon_url] ||= MapiaApiIcon::DEFAULT
  end
  
  def to_js
    js = []
    
    js << "#{self.element_id} = #{@map.element_id}.addMarker('#{self.element_id}', #{js_position}#{js_options});"
    
    return js.join("\n")
  end
  
  def js_position
  	return "null" if self.position.nil?
  	return "{lat:#{self.position[:lat]}, lon:#{self.position[:lat]}}" if self.position.is_a?(Hash)
  	return "{lat:#{self.position[0]}, lon:#{self.position[1]}}" if self.position.is_a?(Array)
  	self.position.include?("#{@map.element_id}.") ? "#{self.position}" : "'#{self.position}'"
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
