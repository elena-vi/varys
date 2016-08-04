class WeatherWidget < Widget

  def name
    :weather
  end

  def url
    "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=a3d9eb01d4de82b9b8d0849ef604dbed"
  end

  def before_condition
    query == name.to_s
  end

  def after_condition
    true
  end

  def parse_json
    { main: @json["weather"][0]["main"],
      description: @json["weather"][0]["description"],
      temperature: @json["main"]["temp"],
      location: @json["name"],
      icon: @json["weather"][0]["icon"] }
  end

end
