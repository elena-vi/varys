require_relative 'result.rb'

class Widgets

  def self.do_widget_search(query_string)
    widgets = {}

    actions = {
      # insert new call words here (as symbols), and the functions they call (declared below)
      # weather: do_weather_search,
      tube: do_tube_search,
      underground: do_tube_search,
      status: do_tube_search,
      example: do_example_search
    }

    actions.each do |key, value|
      if query_string.include?(key.to_s)
        widgets[key] = value
      end
    end

    # declare any widgets here that run on any query
    widgets[:wikipedia] = do_wikipedia_search(query_string)

    widgets
  end

  private

  def self.do_wikipedia_search(query_string)
    return [] if query_string == ""
    url = "https://en.wikipedia.org/w/api.php?action=opensearch&search=#{query_string}&limit=1&namespace=0&format=json"
    response = RestClient.get(url)
    prettify_wikipedia_json(JSON.parse(response))
  end

  def self.do_tube_search
    url = "https://api.tfl.gov.uk/line/mode/tube,overground,dlr,tflrail/status"
    response = RestClient::Request.execute(:url => url, :method => :get, :verify_ssl => false)
    JSON.parse(response)
  end

  def self.do_example_search
    "HEY I'M AN EXAMPLE"
  end

  def self.prettify_wikipedia_json(json)
    description = json[2][0] ? json[2][0] : ""
    output = [Result.new(title: json[1][0], url: json[3][0], description: description)]

    output_description = output.first.description
    return [] if output_description.include? 'may refer to'

    output
  end
end
