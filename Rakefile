require 'yaml'
require 'bcrypt'

task default: :config

task :config do
  if File.file?('config.yml')
    print 'Overwrite the existing config [yN] '
    return unless /^[Yy]/ =~ gets.chomp
  end
  print 'Enter a username: '
  config = { login: { username: gets.chomp } }
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
    number = gets.chomp
    break if number.empty?
    config[:numbers] << number
  end
  File.open('config.yml', 'w') { |f| f.write(config.to_yaml) }
end
