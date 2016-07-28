ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'

require_relative 'server'
require_relative 'nobrainer_setup'
require_relative 'controllers/home'
require_relative 'controllers/results'
