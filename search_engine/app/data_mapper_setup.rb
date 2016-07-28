require 'rubygems'
require 'data_mapper'

require_relative 'models/webpage'

DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                 'postgres://localhost/varys_' + ENV['RACK_ENV'])

DataMapper.finalize
DataMapper.auto_upgrade!
