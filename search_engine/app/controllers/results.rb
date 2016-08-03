class Varys < Sinatra::Base
  get '/results' do
    @now = Time.now
    @query = params[:q]
    @start = params[:start] || "0"
    @count = Webpage.get_all_results(@query).length
    @results = Webpage.do_search(@query, @start)
    erb :'results/index'
  end
end
