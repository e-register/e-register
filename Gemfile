source 'https://rubygems.org'

ENV['DB'] ||= 'sqlite'

gem 'rails', '4.2.1'

# Install the proper gem according to the used database
if ENV['DB'] == 'sqlite'
  gem 'sqlite3'
else
  gem 'pg'
end

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'


gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'therubyracer'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'


group :development do
  # Only in the development environment because the Travis build with ruby < 2 fail with this
  gem 'byebug'
  gem 'web-console', '~> 2.0'

  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rack-mini-profiler'
end

group :development, :test do
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'coveralls', require: false
end

gem 'rspec-rails', group: [ :development, :test ]
group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'poltergeist'
end
