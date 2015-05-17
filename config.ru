require_relative './app'
abort('Missing config file. ' \
  'Run `rake` to generate one') unless File.file?('config.yml')
run ApartmentIntercomAdapter::Application
