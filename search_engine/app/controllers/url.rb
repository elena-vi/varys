class Varys < Sinatra::Base

  get '/url' do
    webpage = Webpage.get_by_id(params[:w])
    p webpage
    webpage.clicks += 1
    webpage.save!
    redirect to(webpage.url)
  end

end
