require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/namespace'

require_relative './helpers/twilio_helper'
require_relative './helpers/authentication_helper'

module ApartmentIntercomAdapter
  class Application < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace
    include TwilioHelper

    config_file 'config.yml'
    configure do
      enable :sessions
    end

    namespace '/admin' do
      helpers AuthenticationHelper
      before { authenticate unless request.path_info == '/admin/login' }

      get do
        'Dashboard'
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
      'Hello, world!'
    end

    get '/call' do
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
