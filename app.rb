require 'json'
require 'bundler'
Bundler.require(:sinatra)

require_relative './helpers/twilio_helper'
require_relative './helpers/authentication_helper'

module ApartmentIntercomAdapter
  class Application < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace
    register Sinatra::AssetPipeline
    helpers TwilioHelper, AuthenticationHelper

    config_file 'config.yml'
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
      helpers AuthenticationHelper
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
      dial_numbers(*settings.numbers)
    end

    get '/call_end' do
      content_type :xml
      no_one_home if params[:DialCallStatus] == 'no-answer' ||
                     params[:DialCallStatus] == 'busy'
    end
  end
end
