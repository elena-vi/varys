class Varys < Sinatra::Base
  get '/results' do
    @now = Time.now
    @query = params[:q]
    @start = params[:start].to_i || 0
    @count = Webpage.do_search(@query, @start)[:count]
    @results = Webpage.do_search(@query, @start)[:results]
    erb :'results/index'
  end
end
