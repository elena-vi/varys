ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'

require_relative 'server'
require_relative 'controllers/home'
