class Varys < Sinatra::Base
  get '/results' do
    @now = Time.now
    @query = params[:q]
    @start = params[:start] || "0"
    @results = Webpage.do_search(@query, @start)
    @results.each do |result|
      puts result.id
      puts result.title
      puts result.url
      puts result.description
    end
    @widgets = Widgets.do_widget_search(@query)
    erb :'results/index'
  end
end
