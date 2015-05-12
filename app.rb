require 'sinatra'

class ApartmentIntercomAdapter < Sinatra::Base
  get '/' do
    'Hello, world!'
  end
end
