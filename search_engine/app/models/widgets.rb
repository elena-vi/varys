require_relative 'result.rb'

class Widgets

  SOURCES = { tube: {
                  name: 'tube',
                  url: "https://api.tfl.gov.uk/line/mode/tube,overground,dlr,tflrail/status",
                  condition: Proc.new { |query| query.include?('tube') }
                },
              wikipedia: {
                  name: 'wikipedia',
                  url: "https://en.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=1&namespace=0&format=json",
                  condition: Proc.new { true }
                }
            }

  def self.all(query_string)
    SOURCES.select{ |name, widget| widget[:condition].call(query_string) }.map do |name, widget|
      [name, Widgets.new(name, query_string).get]
    end.to_h
  end

  def initialize(widget, query_string)
    @widget = widget
    @url = SOURCES[widget][:url] % query_string
  end

  def get
    response = RestClient::Request.execute(:url => @url, :method => :get, :verify_ssl => false)
    prettify_json(@widget, JSON.parse(response))
  end

  private

  def prettify_json(widget, json)
    return prettify_tube_json(json) if widget == :tube
    return prettify_wikipedia_json(json) if widget == :wikipedia
  end

  def prettify_tube_json(json_results)
    result = []

    json_results.each do |line|
      result << { id: line["id"], name: line["name"], status: line["lineStatuses"][0]["statusSeverityDescription"], reason: line["lineStatuses"][0]["reason"]}
    end

    result
  end

  def prettify_wikipedia_json(json)
    description = json[2][0] ? json[2][0] : ""
    output = [Result.new(title: json[1][0], url: json[3][0], description: description)]

    output_description = output.first.description
    return [] if output_description.include? 'may refer to'

    output
  end
end
