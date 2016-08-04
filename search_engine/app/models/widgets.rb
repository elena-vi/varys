require_relative 'result.rb'

class Widgets

  SOURCES = [
              { name: 'weather',
                url: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=a3d9eb01d4de82b9b8d0849ef604dbed",
                before_condition: -> (widg) { widg.query == 'weather' },
                after_condition: -> (widg) { true },
                parse_json: -> (json) { {
                  main: json["weather"][0]["main"],
                  description: json["weather"][0]["description"],
                  temperature: json["main"]["temp"]
                }}
              },
              { name: 'tube',
                url: "https://api.tfl.gov.uk/line/mode/tube,overground,dlr,tflrail/status",
                before_condition: -> (widg) { widg.query == 'tube' },
                after_condition: -> (widg) { true },
                parse_json: -> (json) { 
                  json.map { |line| 
                    { id: line["id"],
                      name: line["name"],
                      status: line["lineStatuses"][0]["statusSeverityDescription"],
                      reason: line["lineStatuses"][0]["reason"]
                    }
                  }
                }
              },
              { name: 'wikipedia',
                url: "https://en.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=1&namespace=0&format=json",
                before_condition: -> (widg) { widg.query != 'weather' && widg.query != 'tube'},
                after_condition: -> (widg) { !widg.json.first.description.empty? && !widg.json.first.description.include?('may refer to') },
                parse_json: -> (json) { [Result.new(
                  title: json[1][0],
                  url: json[3][0],
                  description: json[2][0] || "")
                ]}
              }
            ]

  def self.all(query)
    SOURCES.map { |widget| [widget[:name].to_sym, Widgets.new(widget, query).get] }.to_h.delete_if{ |k,v| !v }
  end

  attr_reader :name, :url, :query, :json
  
  def initialize(widget, query)
    @name = widget[:name]
    @url = widget[:url] % query
    @query = query
    @before_condition = widget[:before_condition]
    @after_condition = widget[:after_condition]
    @parse_json = widget[:parse_json]
  end

  def get
    return nil unless @before_condition.(self)
    response = RestClient::Request.execute(:url => @url, :method => :get, :verify_ssl => false)
    @json = @parse_json.(JSON.parse(response))
    return nil unless @after_condition.(self)
    json
  end
end
