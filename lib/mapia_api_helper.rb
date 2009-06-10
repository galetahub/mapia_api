# http://mapia.ua/api_static_docs.html
# Статическое API Mapia предоставляет Вам возможность разместить у себя на 
# сайте фрагмент карты с информацией об объекте.
# Статический API Mapia При помощи этого тега вы сможете вставить определенную 
# часть карты с необходимым вам адресом на страницу вашего сайта: 
# <img src="http://mapia.ua/static?address=Крещатик 22&marker_title=Почтовое отделение&size=500x500&zoom=18&lang=ru&city=Киев">

# Серым выделены фрагменты, которые необходимо изменять, где:
# city — название города, карту которого хотите отобразить. Это может быть любой город из тех, что предоставляет наш проект.
# address — адрес объекта, который надо показать. Карта будет центрирована по этому адресу, и метка будет стоять именно по этому адресу.

# Рекомендация: убедитесь, что такой адрес существует, и что вы правильно его написали. 
# В противном случае вы получите вместо карты надпись «Адрес не найден»

# marker_title — содержание метки. Вы можете написать тут любой текст, который хотите отобразить на метке — адрес, название объекта, описание и т.д.
# size — размер отображаемой карты в пикселях. В зависимости от того, какого размера вам нужна карта, вы выставляете необходимые вам параметры.
# lang — (необязательный параметр) язык, на котором будут отображены надписи на карте. (ru, ua)
# zoom — уровень высоты, с которой генерируется фрагмент. Значение может быть от 6 до 18, где 6 — максимальное отдаление, а 18 максимальное приближение к карте.
# encoding — кодировка в которой передаются параметры. По умолчанию UTF-8. Альтернативный вариант - CP1251 (для кодировки windows) 
module MapiaApiHelper
  
  @@default_mapia_options = {
    :size=>'500x500',
    :lang=>'ru',
    :zoom=>16,
    :encoding=>'UTF-8',
    :city=>'Киев'
  }
  
  def mapia_image_map(address, options={})
    @options = @@default_mapia_options.merge(options.symbolize_keys)
    @options[:address] = address
    image_tag("http://mapia.ua/static?#{extract(@options)}", :alt=>address, :title=>address)
  end
  
  private
  
  def extract(options={})
    str = []
    options.each do |k, v|
      str << "#{k}=#{v}"
    end
    str.join('&')
  end
end
