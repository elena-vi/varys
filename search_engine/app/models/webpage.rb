class Webpage
  include DataMapper::Resource

  property :id, Serial
  property :title, String, length: 255, required: true
  property :description, String, length: 255, required: true
  property :url, String, length: 255, required: true
  property :rank, Float
  property :clicks, Integer, default: 0

  def self.do_search(query_string, query_from)
    return [] if query_string == ""

    results = self.find_by_sql("SELECT id, title, description, url, clicks, ts_rank_cd(textsearch, query) AS rank
                                FROM webpages, plainto_tsquery('english', '#{query_string}') query, to_tsvector(url || title || description) textsearch
                                WHERE query @@ textsearch
                                ORDER BY rank DESC")

    # LIMIT 10 OFFSET #{query_from}

    # need to add function for checking if result is query homepage (if query string has no spaces)
    #
    # popularity table?
    #
    # loop through database again for both and adjust ranking accordingly

    result_objects = convert_results_to_objects(results)

    result_objects.each do |result|
      url_length = get_extra_nodes(result.url).length
      result.rank -= (result.rank * 0.25) * url_length
      result.rank *= 1.5 if url_length == 0
      result.clicks.times { result.rank *= 1.02 }
    end

    result_objects.sort_by! do |result|
      result.rank
    end

    result_objects.reverse
  end

  def self.get_extra_nodes(url)
    site_nodes = url.split(/[\/]/)
    url_parts = ["http:", "https:", ""]
    site_nodes - url_parts - [get_root(url)]
  end

  def self.get_root(url)
    site_nodes = url.split(/[\/]/)
    site_nodes[2]
  end

  def self.get_homepage(site_root)
    url_parts = ["www", "org", "uk", "gov", "com", "co"]
    site_root.split('.') - url_parts
  end

  def self.get_all_results(query_string)
    results = self.find_by_sql("SELECT id, title, description, url, ts_rank_cd(textsearch, query) AS rank
                                FROM webpages, plainto_tsquery('english', '#{query_string}') query, to_tsvector(url || title || description) textsearch
                                WHERE query @@ textsearch
                                ORDER BY rank DESC")

    convert_results_to_objects(results)
  end

  private

  def self.convert_results_to_objects(results)
    results.map do |result|
      Webpage.new(title: result['title'],
                  url: result['url'],
                  description: result['description'],
                  clicks: result['clicks'],
                  rank: result['rank'])
    end

    results
  end
end
