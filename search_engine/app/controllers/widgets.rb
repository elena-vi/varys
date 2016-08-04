class Varys < Sinatra::Base
  get '/widgets' do
    @widgets = Widgets.all(params[:q])
    erb :'widgets/index'
  end
end
