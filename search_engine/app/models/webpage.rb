class Webpage

  require 'pg'

  # include DataMapper::Resource

  # property :id, Serial
  # property :title, String, length: 255, required: true
  # property :description, String, length: 255, required: true
  # property :url, String, length: 255, required: true
  # property :rank, String

  attr_reader :title, :description, :url, :rank

  def initialize(title, url, description, rank)
    @title = title
    @url = url
    @description = description
    @rank = rank
  end

  def self.do_search(query_string, query_from)
    return [] if query_string == ""

    # results = self.find_by_sql("SELECT id, title, description, url, ts_rank_cd(textsearch, query) AS rank
    #                             FROM webpages, plainto_tsquery('english', '#{query_string}') query, to_tsvector(url || title || description) textsearch
    #                             WHERE query @@ textsearch
    #                             ORDER BY rank DESC
    #                             LIMIT 10 OFFSET #{query_from}")

    begin
      # results.clear if results
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
      print '---------------'
      print "CLOSE"
      print "---------------\n"
    end

    # need to add function for checking if result is query homepage (if query string has no spaces)
    #
    # popularity table?
    #
    # loop through database again for both and adjust ranking accordingly
    print "---------------"
    print results
    print "---------------\n"
    convert_results_to_objects(results)
  end

  private

  def self.convert_results_to_objects(results)
    print '---------------'
    print "CONVERT"
    print "---------------\n"
    results.map do |result|
      print "--res-----\n"
      print result['title']
      print "--res-----\n"

      Webpage.new(result['title'], result['url'], result['description'], result['rank'])
    end
    print "---------------"
    print results.values
    print "---------------\n"
    results
  end
end
