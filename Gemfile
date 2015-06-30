source 'https://rubygems.org'

gem 'twilio-ruby'
gem 'rack'
gem 'rake'
gem 'bcrypt'

group :sinatra do
  gem 'sinatra', require: 'sinatra/base'
  gem 'sinatra-contrib', require: ['sinatra/config_file', 'sinatra/namespace']
  gem 'sinatra-asset-pipeline', require: 'sinatra/asset_pipeline'

  source 'https://rails-assets.org' do
    gem 'rails-assets-knockoutjs'
    gem 'rails-assets-jquery'
    gem 'rails-assets-bootstrap-sass'
  end
end

group :development do
  gem 'thin'
  gem 'rerun'
end

group :production do
  gem 'unicorn'
end
