require_relative 'result.rb'

class Widgets

  SOURCES = { tube:
                [
                  "https://api.tfl.gov.uk/line/mode/tube,overground,dlr,tflrail/status",
                  Proc.new { |query| query.include?('tube') }
                ],
              wikipedia:
                [
                  "https://en.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=1&namespace=0&format=json",
                  Proc.new { true }
                ]
            }

  def self.all(query_string)
    actions = {}

    SOURCES.each do |widget, (url, condition)|
      actions[widget] = Widgets.new(widget, query_string).get if condition.call(query_string)
    end

    # map = SOURCES.map do |widget, (url, condition)|
    #   [(widget.to_sym) => Widgets.new(widget, query_string).get]
    # end.compact
    #
    # p '--------------map'
    # puts map
    #
    # p '---------------actions'
    # puts actions

    actions
  end

  def initialize(widget, query_string)
    @widget = widget
    @url = SOURCES[widget][0] % query_string
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
