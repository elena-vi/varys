class Varys < Sinatra::Base
  get '/results' do
    @query = params[:q]
    # see Webpage model for method
    @results = Webpage.do_search(@query)
    erb :'results/index'
  end
end
