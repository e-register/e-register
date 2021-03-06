source 'https://rubygems.org'

gem 'rails', '4.2.1'

gem 'sqlite3', group: [:development, :test]
gem 'pg'

gem 'activerecord_any_of'
gem 'activerecord-import'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'


gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'nprogress-rails'
gem 'jbuilder', '~> 2.0'
gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-datepicker-rails'
gem 'nav_lynx'

gem 'devise'
gem 'pundit'

gem 'rdiscount'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'database_cleaner'
gem 'faker'
gem 'ffaker'

gem 'rack-mini-profiler'

group :development do
  # Only in the development environment because the Travis build with ruby < 2 fail with this
  gem 'byebug'
  gem 'web-console', '~> 2.0'

  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'coveralls', require: false

  gem 'launchy'
end

gem 'rspec-rails', group: [ :development, :test ]
group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'poltergeist'
end

gem 'rails_12factor', group: :production
gem 'puma', group: :production
