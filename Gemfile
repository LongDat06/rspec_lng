source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'capistrano',         require: false
  gem 'capistrano-rbenv',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-rake', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'mongoid', '~> 7.2.0'
gem 'bson'
gem 'fast_jsonapi'
gem 'redis', '4.2.5'
gem 'redis-rails', '5.0.2'
gem 'dotenv-rails'
gem 'virtus'
gem 'httparty'
gem 'pagy', '~> 3.10'
gem 'enumerize'
gem 'rack-cors', :require => 'rack/cors'
gem 'creek', git: 'https://github.com/pythonicrubyist/creek'
gem 'shrine', "~> 3.0"
gem 'shrine-mongoid', "~> 1.0"
gem 'aws-sdk-s3'
gem 'ais', path: 'domains/ais'
gem 'weather', path: 'domains/weather'
gem 'analytic', path: 'domains/analytic'