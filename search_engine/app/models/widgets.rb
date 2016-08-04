class Widgets

  SOURCES = [
              { name: :weather,
                url: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=a3d9eb01d4de82b9b8d0849ef604dbed",
                before_condition: -> (widg) { widg.query == 'weather' },
                after_condition: -> (widg) { true },
                parse_json: -> (json) {
                  { main: json["weather"][0]["main"],
                    description: json["weather"][0]["description"],
                    temperature: json["main"]["temp"],
                    location: json["name"],
                    icon: json["weather"][0]["icon"]
                  }
                }
              },
              { name: :tube,
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
              { name: :wikipedia,
                url: "https://en.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=1&namespace=0&format=json",
                before_condition: -> (widg) { widg.query != 'weather' },
                after_condition: -> (widg) { !widg.json[:description].empty? && !widg.json[:description].include?('may refer to') },
                parse_json: -> (json) {
                  { title: json[1][0],
                    url: json[3][0],
                    description: json[2][0] || ""
                  }
                }
              }
            ]

  def self.all(query)
    SOURCES.map { |source| Widgets.new(source, query).populate }.compact
  end

  attr_reader :name, :url, :query, :json

  def initialize(source, query)
    @name = source[:name]
    @url = source[:url] % query
    @query = query
    @before_condition = source[:before_condition]
    @after_condition = source[:after_condition]
    @parse_json = source[:parse_json]
  end

  def populate
    return nil unless @before_condition.(self)
    @json = @parse_json.(fetch_json)
    return nil unless @after_condition.(self)
    self
  end

  def fetch_json
    response = RestClient::Request.execute(:url => @url, :method => :get, :verify_ssl => false)
    JSON.parse(response)
  end

end
