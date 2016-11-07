require 'faker'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.definition_file_paths = %w{./factories ./spec/factories}
FactoryGirl.find_definitions
