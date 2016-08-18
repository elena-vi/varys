class Webpage
  include DataMapper::Resource

  property :id, Serial
  property :title, String, length: 255
  property :url, String, length: 255
  property :description, String, length: 255
  property :rank, String
  property :clicks, Integer

  def self.add_click(id)
    webpage = self.get(id)
    webpage.clicks += 1
    webpage.save
    webpage
  end

  def self.do_search(query_string, query_from)
    return [] if query_string == ""

    p query_from

    sql = "SELECT id, title, description, url, clicks,
                  ts_rank_cd(textsearch, query) AS rank
           FROM webpages,
           plainto_tsquery('english', '#{query_string}') query,
           to_tsvector(url || title || description) textsearch
           WHERE query @@ textsearch
           ORDER BY rank DESC"

    p sql

    results = map_to_objects(self.find_by_sql(sql))

    p results

    results.each do |result|
      url_length = get_extra_nodes(result.url).length
      result.rank -= (result.rank * 0.25) * url_length
      result.rank *= 1.5 if url_length == 0
      result.rank += (result.clicks * 0.01)
    end

    results.sort_by! do |result|
      result.rank
    end

    {results: results.reverse[query_from..query_from+9], count: results.length }
  end

  def self.get_result_count(query_string)
    sql = "SELECT id, title, description, url, clicks,
                  ts_rank_cd(textsearch, query) AS rank
           FROM webpages,
           plainto_tsquery('english', '#{query_string}') query,
           to_tsvector(url || title || description) textsearch
           WHERE query @@ textsearch
           ORDER BY rank DESC"

    map_to_objects(self.find_by_sql(sql)).length
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

  private

  def self.map_to_objects(results)
    objects = []

    results.each do |result|
      objects << Result.new(
        id: result['id'],
        title: result['title'],
        url: result['url'],
        description: result['description'],
        rank: result['rank'].to_f,
        clicks: result['clicks'].to_i
      )
    end

    objects
  end
end
