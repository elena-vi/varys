class Webpage
  include DataMapper::Resource

  property :id, Serial
  property :title, String, length: 255, required: true
  property :description, String, length: 255, required: true
  property :url, String, length: 255, required: true

  def self.do_search(query_string)
    return [] if query_string == ""
    # dm-ar-finders installed and required into data_mapper_setup, which allows
    # direct querying of the database (raw SQL) by using find_by_sql on the
    # model.
    #
    # Query:
    # SELECT only the fields we need to display FROM the webpages table WHERE
    # document (created using to_tsvector, a postgres function) matches (@@) a
    # query (to_tsquery). 'english' is specified inside both the document and
    # query functions so pluralized words etc. are treated the same - e.g
    # fox and foxes return the same result.
    # An OR has been added so if a user inputs the website address directly
    # without the http://, www or ending then it should still bring up a result
    # (postgres full text searching looks for whole words/strings so won't
    # match a partial url, thus we have to use LIKE)
    results = self.find_by_sql("SELECT id, title, description, url
                                FROM webpages
                                WHERE to_tsvector('english', title || description)
                                @@ plainto_tsquery('english', '#{query_string}')
                                OR    url LIKE '%#{query_string}%'")

    convert_results_to_objects(results)
  end

  private

  def self.convert_results_to_objects(results)
    # Raw sql queries don't return results as objects, so replaced every result
    # with a new instance of Webpage (new doesn't save to the db)
    results.map do |result|
      Webpage.new(title: result['title'],
                  url: result['url'],
                  description: result['description'])
    end

    results
  end
end
