class Varys < Sinatra::Base
  register Sinatra::Partial

  set :views, Proc.new { File.join(root, 'views') }
  set :public_folder, proc { File.join(root, 'views/public') }

  set :partial_template_engine, :erb
  enable :partial_underscores

  helpers Helpers
end
