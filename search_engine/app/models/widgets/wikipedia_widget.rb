class WikipediaWidget < Widget

  def name
    :wikipedia
  end

  def url
    "https://en.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=1&namespace=0&format=json" % query
  end

  def before_condition
    query != 'weather'
  end

  def after_condition
    !@json[:description].empty? && !@json[:description].include?('may refer to')
  end

  def parse_json
    { title: @json[1][0],
      url: @json[3][0],
      description: @json[2][0] || "" }
  end

end
