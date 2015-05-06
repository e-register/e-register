# Prepare the Coveralls Environment
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

require 'pundit/rspec'

# Load support files
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Skip because of database_cleaner
  config.use_transactional_fixtures = false

  # Add the support for Capybara
  config.include Capybara::DSL

  # Add the support for FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Setup the database cleaner gem to clean the database with transactions,
  # if the example requires javascript clean with truncation
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Add the support for stubbing the login
  config.include Devise::TestHelpers, type: :controller
  config.include DeviseControllerMacros, type: :controller
  config.include Warden::Test::Helpers, type: :request
  config.include DeviseRequestMacros, type: :request

  config.include ApplicationHelper

  # Enable the Warden Debug Mode to allow the current_user stubbing
  config.around(:each) do |example|
    Warden.test_mode!
    example.run
    Warden.test_reset!
  end

  # Speedup the tests reducing the security of the hash algorithm
  BCrypt::Engine.cost = 1

  # Enable SQL Logging
  # ActiveRecord::Base.logger = Logger.new(STDOUT)
end
