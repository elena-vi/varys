class TubeWidget < Widget

  def name
    :tube
  end

  def url
    "https://api.tfl.gov.uk/line/mode/tube,overground,dlr,tflrail/status"
  end

  def before_condition
    query == name.to_s
  end

  def after_condition
    true
  end

  def parse_json
    @json.map { |line|
      { id: line["id"],
        name: line["name"],
        status: line["lineStatuses"][0]["statusSeverityDescription"],
        reason: line["lineStatuses"][0]["reason"]
      }
    }
  end

end
