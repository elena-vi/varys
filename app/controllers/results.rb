class Varys < Sinatra::Base
  get '/results' do
    @now = Time.now
    @query = params[:q]
    @start = params[:start].to_i || 0
    @results_with_count = Webpage.do_search(@query, @start)
    @results = @results_with_count[0]
    @count = @results_with_count[1] || 0
    erb :'results/index'
  end
end
