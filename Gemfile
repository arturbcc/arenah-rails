source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

# Core gems
gem 'devise'
gem 'devise-encryptable'
gem 'friendly_id', '~> 5.1.0'
gem 'pg', '~> 0.18'
gem 'rails', '5.1.4'

# Frontend gems
# Use Uglifier as compressor for JavaScript assets
gem 'bootstrap-sass'
gem 'ckeditor'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate-bootstrap'

# Business logic related gems
gem 'ruby-bbcode'
gem 'carrierwave'
gem 'dentaku'
gem 'mini_magick'
gem 'rails-html-sanitizer'

# Rake related gems
gem 'colorize', require: false
gem 'rake-progressbar', require: false

# Analytics gems
gem 'newrelic_rpm'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'puma', '~> 5.5'
  gem 'rack-mini-profiler'
  gem 'rubocop', '~> 0.48.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 3.3.0'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'vcr'
end

group :production do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
