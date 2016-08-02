class Webpage
  include DataMapper::Resource

  property :id, Serial
  property :title, String, length: 255, required: true
  property :description, String, length: 255, required: true
  property :url, String, length: 255, required: true
  property :rank, String

  def self.do_search(query_string, query_from)
    return [] if query_string == ""

    results = self.find_by_sql("SELECT id, title, description, url, ts_rank_cd(textsearch, query) AS rank
                                FROM webpages, plainto_tsquery('english', '#{query_string}') query, to_tsvector(url || title || description) textsearch
                                WHERE query @@ textsearch
                                ORDER BY rank DESC
                                LIMIT 10 OFFSET #{query_from}")

    # need to add function for checking if result is query homepage (if query string has no spaces)
    #
    # popularity table?
    #
    # loop through database again for both and adjust ranking accordingly

    convert_results_to_objects(results)
  end

  private

  def self.convert_results_to_objects(results)
    results.map do |result|
      Webpage.new(title: result['title'],
                  url: result['url'],
                  description: result['description'],
                  rank: result['rank'])
    end

    results
  end
end
