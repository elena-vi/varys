class Widget
  attr_reader :json, :query

  def initialize(query)
    @query = query
  end

  def view
    :"partials/_#{name}"
  end

  def populate
    return nil unless before_condition
    @json = fetch_json
    @json = parse_json
    return nil unless after_condition
    self
  end

  def fetch_json
    response = RestClient::Request.execute(:url => url, :method => :get, :verify_ssl => false)
    JSON.parse(response)
  end

end
