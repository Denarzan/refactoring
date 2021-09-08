require 'simplecov'
require 'undercover'
require 'i18n'
SimpleCov.start do
  add_filter(%r{/spec/})
end

require_relative '../src/account/account'
require_relative '../src/console/console'

I18n.load_path << Dir["#{File.expand_path('../config/locales', __dir__)}/*.yml"]
I18n.default_locale = :en

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
