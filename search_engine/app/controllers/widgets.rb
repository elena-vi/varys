class Varys < Sinatra::Base
  get '/widgets' do
    @query = params[:q]
    @widgets = Widgets.do_widget_search(@query)
    erb :'widgets/index'
  end
end
