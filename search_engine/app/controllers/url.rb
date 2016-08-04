class Varys < Sinatra::Base

  get '/url' do
    webpage = Webpage.add_click(params[:w])
    redirect to(webpage.url)
  end

end
