require 'twilio-ruby'

module ApartmentIntercomAdapter
  module TwilioHelper
    def dial_numbers(*args)
      Twilio::TwiML::Response.new do |r|
        r.Dial hangupOnStar: true, timeLimit: 120, timeout: 5,
               action: '/call_end', method: 'GET' do |d|
          args.each { |n| d.Number n }
        end
      end.text
    end

    def no_one_home
      Twilio::TwiML::Response.new do |r|
        r.Say 'There is no one home. Goodbye.'
      end.text
    end
  end
end
