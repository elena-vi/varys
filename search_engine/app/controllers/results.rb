require 'nobrainer'

class Varys < Sinatra::Base
  get '/results' do
    @query = params[:q]
    @results = Webpage.all
    erb :'results/index'
  end
end
