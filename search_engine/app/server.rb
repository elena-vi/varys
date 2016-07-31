class Varys < Sinatra::Base
  register Sinatra::Partial

  set :views, Proc.new { File.join(root, 'views') }
  
  set :partial_template_engine, :erb
  enable :partial_underscores
end
