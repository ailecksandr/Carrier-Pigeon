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

set :environment, :test

require 'factory_girl'
require 'timecop'
require 'shoulda/matchers'
require 'faker'
require_relative 'support/factory_girl'
require 'database_cleaner'

FactoryGirl.definition_file_paths = %w{./factories ./spec/factories}
FactoryGirl.find_definitions

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
  end
end

RSpec.configure do |config|
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