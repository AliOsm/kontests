source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.6.6'

# Use FontAwesome as default font icon
gem 'font-awesome-sass', '~> 5.0.13'
# Use Watir to navigate dynamic sites
gem 'watir', '~> 6.0'
# Use simple_form to generate simple forms!
gem 'simple_form', '~> 5.0.0'
# Use validates_email_format_of to validate emails!
gem 'validates_email_format_of', '~> 1.6', '>= 1.6.3'
# Use validate_url to validate urls!
gem 'validate_url', '~> 1.0', '>= 1.0.2'
# Use Twemoji as default emoji set
gem 'twemoji', '~> 3.1', '>= 3.1.4'
# Use clockwork to create periodic tasks
gem 'clockwork', '~> 1.2', require: false
# Use Timeago as default relative time converter
gem 'rails-timeago', '~> 2.16'
# Use google-analytics-rails as default Google Analytics gem
gem 'google-analytics-rails', '1.1.1'
# Use rack-cors
gem 'rack-cors', :require => 'rack/cors'
# Use Nokogiri for crawling
gem 'nokogiri', '>= 1.10.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Use pg as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'webdrivers', '~> 4.0'
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
