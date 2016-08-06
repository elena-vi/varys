class Varys < Sinatra::Base
  get '/widgets' do
    @widgets = WidgetBuilder.all(params[:q])
    erb :'widgets/index'
  end
end
