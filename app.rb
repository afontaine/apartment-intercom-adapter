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

require 'json'
require 'bundler'
require 'uri'
Bundler.require(:sinatra)

require_relative './helpers/twilio_helper'
require_relative './helpers/authentication_helper'
require_relative './helpers/config_helper.rb'

module ApartmentIntercomAdapter
  class Application < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace
    register Sinatra::AssetPipeline
    helpers TwilioHelper, AuthenticationHelper

    config_file 'config/config.yml'
    configure do
      enable :sessions
      set :assets_precompile, %w(application.js application.css)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end if defined?(RailsAssets)
    end

    namespace '/admin' do
      before do
        authenticate do
          redirect to('/admin/login')
        end unless request.path_info == '/admin/login'
      end

      get do
        @numbers = settings.numbers
        erb :form
      end

      get '/login' do
        erb :login
      end

      post '/login' do
        authenticate_user(params[:username], params[:password])
        redirect to('/admin')
      end

      get '/logout' do
        deauthenticate
        redirect to('/login')
      end
    end

    namespace '/api' do
      helpers AuthenticationHelper, ConfigHelper
      before do
        authenticate do
          status 403
        end unless request.path_info == '/admin/login'
      end

      get '/numbers', provides: :json do
        content_type :json
        settings.numbers.to_json
      end

      post '/numbers', provides: :json do
        content_type :json
        update_numbers('config/config.yml', params[:numbers])
        (settings.numbers = params[:numbers]).to_json
      end

      put '/numbers/:number', provides: :json do
        content_type :json
        settings.numbers << params[:number]
        settings.numbers.uniq.to_json
      end

      delete '/numbers/:number', provides: :json do
        content_type :json
        settings.numbers.delete(params[:number])
        settings.numbers.to_json
      end
    end

    get '/' do
      @numbers = settings.numbers
      erb :index
    end

    get '/call' do
      redirect to('/') unless params[:From]
      content_type :xml
      dial_numbers(*settings.numbers, url: URI(request.url))
    end

    get '/call_end/:number' do
      content_type :xml
      hangup do |r|
        sms_confirmation(
          r,
          settings.numbers,
          number: params[:number]
        ) if params[:DialCallStatus] == 'answered' ||
          params[:DialCallStatus] == 'completed'
        no_one_home if params[:DialCallStatus] == 'no-answer' ||
          params[:DialCallStatus] == 'busy'
      end
    end
  end
end
