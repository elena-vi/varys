class Webpage

  attr_reader :title, :description, :url, :rank
  attr_accessor :id, :clicks

  def initialize(params)
    @id = params.fetch(:id, '')
    @title = params.fetch(:title, "")
    @url = params.fetch(:url, "")
    @description = params.fetch(:description, "")
    @clicks = params.fetch(:clicks, 0)
    @rank = params[:rank].to_f
  end

  def rank=(new_rank)
    begin
      connection = PG.connect(dbname: "varys_#{ENV['RACK_ENV']}")
      id = connection.exec "UPDATE webpages SET rank=#{new_rank} WHERE id=#{self.id};"
    rescue PG::Error => e
      puts e.message
    ensure
      connection.close if connection
    end
    self.id = id
  end

  def self.do_search(query_string)
    return [] if query_string == ""

    begin
      connection = PG.connect(dbname: "varys_#{ENV['RACK_ENV']}")
      results = connection.exec "SELECT id, title, description, url, ts_rank_cd(textsearch, query) AS rank
                                 FROM webpages,
                                 plainto_tsquery('english', '#{query_string}') query,
                                 to_tsvector(url || title || description) textsearch
                                 WHERE query @@ textsearch
                                 ORDER BY rank DESC"

                                 p "============"
                                 p results[0]['rank']
                                 p "============"
    rescue PG::Error => e
      puts e.message
      results = []
    ensure
      connection.close if connection
    end

    result_objects = convert_results_to_objects(results)

    result_objects.each do |result|
      rank = result.rank.to_f
      p rank
      url_length = get_extra_nodes(result.url).length
      rank -= (rank * 0.25) * url_length
      rank *= 1.5 if url_length == 0
      result.rank = rank
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

  def save!
    begin
      connection = PG.connect(dbname: "varys_#{ENV['RACK_ENV']}")
      id = connection.exec "INSERT INTO webpages (title, description, url) VALUES('#{self.title}','#{self.description}','#{self.url}') RETURNING id;"
    rescue PG::Error => e
      puts e.message
    ensure
      connection.close if connection
    end
    self.id = id
  end

  def self.get_by_id(id)
    begin
      connection = PG.connect(dbname: "varys_#{ENV['RACK_ENV']}")
      results = connection.exec "SELECT id, url
                                 FROM webpages,
                                 WHERE id=#{id}"
      p results
    rescue PG::Error => e
      puts e.message
      results = []
    ensure
      connection.close if connection
    end

    p '============'
    p results
    p '============'
    return results
  end

  private

  def self.convert_results_to_objects(query_results)
    results = []
    query_results.each do |result|
      results << Webpage.new( id: result['id'],
                              title: result['title'],
                              url: result['url'],
                              description: result['description'],
                              rank: result['rank'].to_f,
                              clicks: result['clicks']
      )
    end
    p "rrrrrrrrrrrrr"
    p results[0].rank
    p "rrrrrrrrrrrrr"
    results
  end
end
