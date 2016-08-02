class Webpage
  include DataMapper::Resource

  property :id, Serial
  property :title, String, length: 255, required: true
  property :description, String, length: 255, required: true
  property :url, String, length: 255, required: true

  def self.do_search(query_string, query_from)
    return [] if query_string == ""

    results = self.find_by_sql("SELECT *
                                FROM webpages
                                WHERE to_tsvector('english', title || description)
                                @@ plainto_tsquery('english', '#{query_string}')
                                OR url LIKE '%#{query_string}%'
                                LIMIT 10 OFFSET #{query_from}")

    convert_results_to_objects(results)
  end

  private

  def self.convert_results_to_objects(results)
    results.map do |result|
      Webpage.new(title: result['title'],
                  url: result['url'],
                  description: result['description'])
    end

    results
  end
end
