require 'rspec'
require 'questions'

RSpec.configure do |config|
  include Questions

  config.mock_with :rspec

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
