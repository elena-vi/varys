class Varys < Sinatra::Base
  set :views, Proc.new { File.join(root, 'views') }
end
