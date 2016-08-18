ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require 'sinatra/partial'
require 'rest-client'
require 'json'

require_relative 'data_mapper_setup'
require_relative 'helpers'
require_relative 'server'
require_relative 'controllers/home'
require_relative 'controllers/results'
require_relative 'controllers/widgets'
require_relative 'controllers/url'
require_relative 'models/widget_builder'
require_relative 'models/result'
