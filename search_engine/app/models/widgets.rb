require_relative 'result.rb'

class Widgets

  def self.do_widget_search(query_string)
    widgets = {}
    if query_string
      widgets[:wikipedia] = do_wikipedia_search(query_string)
    end
    widgets
  end

  def self.do_wikipedia_search(query_string)
    return [] if query_string == ""
    url = "https://en.wikipedia.org/w/api.php?action=opensearch&search=#{query_string}&limit=1&namespace=0&format=json"
    response = RestClient.get(url)
    prettify_json(JSON.parse(response))
  end

  def self.prettify_json(json)
    description = json[2][0] ? json[2][0] : ""
    output = [Result.new(title: json[1][0], url: json[3][0], description: description)]

    output_description = output.first.description
    return [] if output_description.include? 'may refer to'

    output
  end
end
