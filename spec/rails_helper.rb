# Prepare the Coveralls Environment
require 'coveralls'
Coveralls.wear!('rails')

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Load support files
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

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

  # Force to use transactional fixtures
  config.use_transactional_fixtures = true

  # Add the support for Capybara
  config.include Capybara::DSL

  # Add the support for FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Prepare the database_cleaner gem
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # Clean the database after each test
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Add the support for stubbing the login
  config.include Devise::TestHelpers, type: :controller
  config.include DeviseControllerMacros, type: :controller
  config.include Warden::Test::Helpers, type: :request
  config.include DeviseRequestMacros, type: :request

  # Enable the Warden Debug Mode to allow the current_user stubbing
  config.around(:each) do |example|
    Warden.test_mode!
    example.run
    Warden.test_reset!
  end

  # Speedup the tests reducing the security of the hash algorithm
  BCrypt::Engine.cost = 1
end
