source 'https://rubygems.org'


gem 'rails', '4.2.1'

ENV['DB'] ||= 'sqlite'

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
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Testing...
gem 'rspec-rails', group: [ :development, :test ]
group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
end