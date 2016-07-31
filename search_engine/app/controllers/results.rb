class Varys < Sinatra::Base
  get '/results' do
    @query = params[:q]

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

    @results = Webpage.find_by_sql("SELECT title, description, url
                                    FROM webpages
                                    WHERE to_tsvector('english', title || description) @@ plainto_tsquery('english', '#{@query}')
                                    OR    url LIKE '%#{@query}%'")
    erb :'results/index'
  end
end
