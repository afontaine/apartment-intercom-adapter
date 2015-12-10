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

require 'io/console'
require 'yaml'
require 'bcrypt'
require 'sinatra/asset_pipeline/task'
require_relative './app'

Sinatra::AssetPipeline::Task.define! ApartmentIntercomAdapter::Application

task default: :serve

task :serve => 'config/config.yml' do
  sh 'rackup'
end

task :config => 'config/config.yml'

file 'config/config.yml' do
  if File.file?('config/config.yml')
    print 'Overwrite the existing config [yN] '
    return unless /^[Yy]/ =~ STDIN.gets.chomp
  end
  print 'Enter a username: '
  config = { login: { username: STDIN.gets.chomp } }
  loop do
    print 'Enter a password: '
    password = BCrypt::Password.create(
      STDIN.noecho(&:gets).chomp)
    puts
    print 'Confirm the password: '
    config[:login][:password] = password.to_s
    break if password == STDIN.noecho(&:gets).chomp
    print 'The passwords did not match. Try again.'
  end
  puts
  puts 'Enter phone numbers. Stop entering with a blank line.'
  config[:numbers] = []
  loop do
    number = STDIN.gets.chomp
    break if number.empty?
    config[:numbers] << number
  end
  Dir.mkdir('config') unless File.exists?('config')
  File.open('config/config.yml', 'w') { |f| f.write(config.to_yaml) }
end
