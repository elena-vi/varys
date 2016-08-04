class Widgets
  require_relative 'widgets/widget.rb'
  require_relative 'widgets/wikipedia_widget.rb'
  require_relative 'widgets/tube_widget.rb'
  require_relative 'widgets/weather_widget.rb'


  SOURCES = [WeatherWidget, TubeWidget, WikipediaWidget]

  def self.all(query)
    # SOURCES.map { |source| Widgets.new(source, query).populate }.compact
    SOURCES.map do |source_class|
      source_class.new(query).populate
    end.compact
  end
end
