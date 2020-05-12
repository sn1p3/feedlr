source 'https://rubygems.org'

gem 'rake'
gem 'yard'

group :development do
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
  platforms :ruby_20, :ruby_21, :ruby_22, :ruby_24 do
    gem 'redcarpet'
  end
end

group :test do
  gem 'coveralls', '~> 0.8', require: false
  gem 'rspec', '~> 3.4'
  # gem 'rspec-nc'
  gem 'rubocop', '~> 0.37', platforms: [:ruby_20, :ruby_21, :ruby_22, :ruby_24]
  gem 'simplecov', '~> 0.11', require: false
  gem 'guard', '~> 2.13'
  gem 'guard-rspec', '~> 4.6'
  gem 'webmock', '~> 2.3'
  gem 'vcr', '~> 3.0'
end

# Specify your gem's dependencies in feedlr.gemspec
gemspec
