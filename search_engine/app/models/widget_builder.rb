class WidgetBuilder
  require_relative 'widgets/widget'
  require_relative 'widgets/wikipedia_widget'
  require_relative 'widgets/tube_widget'
  require_relative 'widgets/weather_widget'


  SOURCES = [WeatherWidget, TubeWidget, WikipediaWidget]

  def self.all(query)
    SOURCES.map do |source_class|
      source_class.new(query).populate
    end.compact
  end
end
