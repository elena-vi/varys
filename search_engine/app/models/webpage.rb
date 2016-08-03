class Webpage

  require 'pg'

  attr_reader :id, :title, :description, :url, :rank

  def initialize(params)
    @id = params.fetch(:id, "")
    @title = params.fetch(:title, "")
    @url = params.fetch(:url, "")
    @description = params.fetch(:description, "")
    @rank = params.fetch(:rank, "")
  end

  def self.do_search(query_string, query_from)
    return [] if query_string == ""

    begin
      connection = PG.connect :dbname => 'varys_' + ENV['RACK_ENV']
      results = connection.exec "SELECT id, title, description, url, ts_rank_cd(textsearch, query) AS rank
      FROM webpages, plainto_tsquery('english', '#{query_string}') query, to_tsvector(url || title || description) textsearch
      WHERE query @@ textsearch
      ORDER BY rank DESC
      LIMIT 10 OFFSET #{query_from}"
    rescue PG::Error => e
      puts e.message
      results = []
    ensure
      connection.close if connection
    end

    # need to add function for checking if result is query homepage (if query string has no spaces)
    #
    # popularity table?
    #
    # loop through database again for both and adjust ranking accordingly

    convert_results_to_objects(results)
  end

  def save!

    begin
      connection = PG.connect :dbname => 'varys_' + ENV['RACK_ENV']
      connection.exec "INSERT INTO webpages (title, description, url) VALUES('#{self.title}','#{self.description}','#{self.url}')"
    rescue PG::Error => e
      puts e.message
    ensure
      connection.close if connection
    end

  end

  private

  def self.convert_results_to_objects(query_results)
    results = []
    query_results.map do |result|
      results << Webpage.new( id: result['id'],
      title: result['title'],
      url: result['url'],
      description: result['description'],
      rank: result['rank']
      )
    end
    results
  end
end
