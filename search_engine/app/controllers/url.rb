class Varys < Sinatra::Base

  get '/url' do
    webpage = Webpage.first(id: params[:w])
    webpage.clicks += 1
    webpage.save
    redirect to(webpage.url)
  end

end
