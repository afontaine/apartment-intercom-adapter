require 'bcrypt'

module ApartmentIntercomAdapter
  module AuthenticationHelper
    def authenticated?
      session[:auth]
    end

    def authenticate_user(user, pass)
      session[:auth] = (user == settings.login[:username] &&
        BCrypt::Password.new(settings.login[:password]) == pass)
    end

    def authenticate
      yield unless authenticated?
    end

    def deauthenticate
      session[:auth] = false
    end
  end
end
