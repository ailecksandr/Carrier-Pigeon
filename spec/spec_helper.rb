ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter '/db/'
  add_filter '/config/'
  add_filter '/spec/'
  add_filter 'app/views/'
  add_filter 'app/assets/'
end

require_relative '../app'
require 'rspec'
require 'rack/test'
require 'database_cleaner'

require 'factory_girl'
require_relative 'support/factory_girl'
require 'shoulda/matchers'
require_relative '../lib/form_tags_helper'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_model
    with.library :active_record
  end
end

RSpec::Core::ExampleGroup.include Sinatra::FormHelpers,
                                  Rack::Test::Methods

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include ApplicationHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end