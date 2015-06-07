source 'https://rubygems.org'
ruby '2.1.6'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt-ruby'
gem 'figaro'
gem 'sidekiq'
gem 'unicorn'
gem 'newrelic_rpm'
gem 'carrierwave-aws'
gem "mini_magick"
gem 'stripe', '~> 1.21.0'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver', '~> 2.46.2'
end

group :production do
  gem 'rails_12factor'
end

