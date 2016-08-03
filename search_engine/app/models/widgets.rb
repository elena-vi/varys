require_relative 'result.rb'

class Widgets

  SOURCES = [ { name: 'tube',
                url: "https://api.tfl.gov.uk/line/mode/tube,overground,dlr,tflrail/status",
                before_condition: Proc.new { |query|
                  query.include?('tube')
                },
                after_condition: Proc.new { |json|
                  true
                },
                parse_json: Proc.new { |json|
                  json.map do |line|
                    { id: line["id"], name: line["name"], status: line["lineStatuses"][0]["statusSeverityDescription"], reason: line["lineStatuses"][0]["reason"] }
                  end
                }
              },
              { name: 'wikipedia',
                url: "https://en.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=1&namespace=0&format=json",
                before_condition: Proc.new { |query|
                  true
                },
                after_condition: Proc.new { |json|
                  !json.first.description.empty? && !json.first.description.include?('may refer to')
                },
                parse_json: Proc.new { |json|
                  [Result.new(title: json[1][0], url: json[3][0], description: json[2][0] || "")]
                }
              }
            ]

  def self.all(query)
    SOURCES.map { |widget| [widget[:name].to_sym, Widgets.new(widget, query).get] }.to_h.delete_if{ |k,v| !v }
  end

  def initialize(widget, query)
    @name = widget[:name]
    @url = widget[:url] % query
    @query = query
    @before_condition = widget[:before_condition]
    @after_condition = widget[:after_condition]
    @parse_json = widget[:parse_json]
  end

  def get
    return nil unless @before_condition.call(@query)
    response = RestClient::Request.execute(:url => @url, :method => :get, :verify_ssl => false)
    json = @parse_json.call(JSON.parse(response))
    return nil unless @after_condition.call(json)
    json
  end
end
