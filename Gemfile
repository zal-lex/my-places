# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'devise'
gem 'faker', '2.1.2'
gem 'jbuilder', '~> 2.7'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'carrierwave'
gem 'rmagick'
gem 'fog-aws'
gem 'font_awesome5_rails'
gem "pdfkit"
gem "wkhtmltopdf-binary"
gem 'exception_handler'
gem 'simplecov', require: false, group: :test
gem 'aws-sdk-s3'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'factory_bot_rails'
  gem 'pry'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'lefthook'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'rails_real_favicon'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'webdrivers'
  gem 'json_matchers'
end

group :staging, :production do
  gem "wkhtmltopdf-heroku"
end

