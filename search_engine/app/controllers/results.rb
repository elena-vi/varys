class Varys < Sinatra::Base
  get '/results' do
    @query = params[:q]
    erb :'results/index'
  end
end
