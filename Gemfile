# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Bootstrap 4
gem 'bootstrap', '= 4.0.0.alpha6'
# Bootstrap Forms
gem 'bootstrap_form'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# For html markup
gem 'haml-rails', '~> 1.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# JQuery to use with bootstrap
gem 'jquery-rails'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# DRY up controllers
gem 'responders', '~> 2.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Turbolinks makes navigating your web application faster. Read more:
# https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Validation of URI type fields
gem 'validate_url'

group :development do
  # Detect N+1
  gem 'bullet'
  # Guard and helpers
  gem 'guard'
  gem 'guard-coffeelint', require: false
  gem 'guard-reek', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false

  gem 'listen', '>= 3.0.5', '< 3.2'
  # Pronto for code review
  gem 'pronto', git: 'https://github.com/pettomartino/pronto.git',
                branch: 'fix-new-files'
  gem 'pronto-coffeelint', require: false
  gem 'pronto-flay', require: false
  gem 'pronto-haml', require: false
  gem 'pronto-poper', require: false
  gem 'pronto-rails_best_practices', require: false
  gem 'pronto-reek', require: false
  gem 'pronto-rubocop', require: false
  # Stick to the code!
  gem 'rubocop', '~> 0.50.0'
  # Spring speeds up development by keeping your application running in the
  # background.Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Check unused routes
  gem 'traceroute', require: false
  # Access an IRB console on exception pages or by using <%= console %>
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13', require: false
  # Driver for capybara
  gem 'chromedriver-helper', require: false
  # Cleaning DB on each test
  gem 'database_cleaner', require: false
  # Driver for capybara
  gem 'selenium-webdriver', require: false
  # Code coverage
  gem 'simplecov', '~> 0.15.0', require: false
  # Record http calls for testing
  gem 'vcr', '~> 3.0', '>= 3.0.3'
  # Testing mocks
  gem 'webmock', '~> 3.0', '>= 3.0.1', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Color output
  gem 'coderay', '~> 1.1', '>= 1.1.2'
  # For use instead of fixtures
  gem 'factory_girl_rails'
  # Fake data
  gem 'faker'
  # Testing framework
  gem 'rspec-rails', '~> 3.6'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
