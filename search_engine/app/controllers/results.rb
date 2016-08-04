class Varys < Sinatra::Base
  get '/results' do
    @now = Time.now
    @query = params[:q]
    @results = Webpage.do_search(@query)
    @count = @results.length
    erb :'results/index'
  end
end
