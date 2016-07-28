class Varys < Sinatra::Base
  get '/results' do
    @query = params[:q]
    @results = []
    erb :'results/index'
  end
end
