require 'bcrypt'

module ApartmentIntercomAdapter
  module AuthenticationHelper
    def authenticated?
      session[:auth]
    end

    def authenticate_user(user, pass)
      session[:auth] = (user == settings.login[:username] &&
        pass == BCrypt::Password.new(settings.login[:password]))
    end

    def authenticate
      redirect to('/admin/login') unless authenticated?
    end

    def deauthenticate
      session[:auth] = false
    end
  end
end
