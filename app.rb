require 'sinatra'
require 'sinatra/config_file'

require_relative './helpers/twilio_helper'

module ApartmentIntercomAdapter
  class Application < Sinatra::Base
    register Sinatra::ConfigFile
    include TwilioHelper

    config_file 'config.yml'
    configure do
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
