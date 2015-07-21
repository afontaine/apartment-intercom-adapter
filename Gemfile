# The MIT License (MIT)
#
# Copyright (c) 2015 Andrew Fontaine
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
    gem 'rails-assets-bootswatch-sass'
  end
end

group :production do
  gem 'puma'
end

group :development do
  gem 'rerun'
  gem 'thin'
end
