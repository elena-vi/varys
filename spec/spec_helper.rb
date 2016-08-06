ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'factory_girl'
require 'simplecov'

require File.join(File.dirname(__FILE__), '..', 'app/app.rb')

Capybara.app = Varys

SimpleCov.start

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods

  FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
  FactoryGirl.find_definitions

  config.before(:all) do
    FactoryGirl.reload
  end

  config.after(:each) do
    begin
      connection = PG.connect(dbname: "varys_#{ENV['RACK_ENV']}")
      connection.exec("TRUNCATE webpages;")
    rescue PG::Error => e
      puts e.message
    ensure
      connection.close if connection
    end
  end

  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end
end
