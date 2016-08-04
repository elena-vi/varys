class WidgetBuilder

  require_relative 'widgets/widget'

  CLASS_NAMES = ['WeatherWidget', 'TubeWidget', 'WikipediaWidget']
  WIDGETS_PATH = "widgets/%s"

  def self.all(query)
    CLASS_NAMES.map do |klass|
      require_relative widget_path(klass)
      eval(klass).new(query).populate
    end.compact
  end

  private
 
  def self.widget_path(klass)
    file_name = klass.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    WIDGETS_PATH % file_name
  end

end
