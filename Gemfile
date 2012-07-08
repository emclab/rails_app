source 'http://rubygems.org'

gem 'rails', '~>3.1.4' #latest rail supported for the gem list below

gem 'sqlite3'
gem 'jquery-rails'
gem 'database_cleaner'
gem 'simple_form'
gem 'will_paginate', '~> 3.0'
#gem 'rufus-scheduler'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  group :production do
    gem 'execjs'
    gem 'therubyracer', :platforms => :ruby
  end  
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

# for gem only in development
group :development, :test do
# Pretty printed test output  
  gem "rspec-rails", ">= 2.0.0"
  #gem "cucumber-rails", ">=0.3.2"
  gem 'webrat', ">= 0.7.2"
  gem 'factory_girl_rails', '~> 3.0'
end

#for gem only in test
group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

