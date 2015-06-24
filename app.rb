require 'bundler'
Bundler.require(:sinatra)

require_relative './helpers/twilio_helper'
require_relative './helpers/authentication_helper'

module ApartmentIntercomAdapter
  class Application < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace
    register Sinatra::AssetPipeline
    include TwilioHelper

    config_file 'config.yml'
    configure do
      enable :sessions
      set :assets_precompile, %w(application.js application.css)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end if defined?(RailsAssets)
    end

    namespace '/admin' do
      helpers AuthenticationHelper
      before { authenticate unless request.path_info == '/admin/login' }

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

      post '/logout' do
        deauthenticate
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
