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

require 'bundler/setup'
require 'twilio-ruby'

module ApartmentIntercomAdapter
  module TwilioHelper
    def dial_numbers(*args, url: "")
      url.query = nil
      url.fragment = nil
      Twilio::TwiML::Response.new do |r|
        r.Dial timeLimit: 120 do |d|
          args.each do |n|
            url.path = "/call_end/#{n}"
            d.Number n,
              method: 'GET',
              statusCallback: url.to_s
          end
        end
      end.text
    end

    def no_one_home(r)
      r.Say 'There is no one home. Goodbye.'
    end

    def sms_confirmation(r, args, number: "")
      args.each do |n|
        r.Sms "Door answered by #{number}", to: n
      end
    end

    def hangup
      Twilio::TwiML::Response.new do |r|
        yield r
        r.Hangup
      end.text
    end
  end
end
