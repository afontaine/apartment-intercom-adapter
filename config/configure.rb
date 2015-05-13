require 'yaml'

module ApartmentIntercomAdapter
  module Configure
    extend self

    @_settings = {}
    attr_reader :_settings

    def load!(filename)
      deep_merge!(@_settings, YAML.load_file(filename))
    end

    def deep_merge!(target, data)
      merger = proc do |_, v1, v2|
        v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2
      end
      target.merge! data, &merger
    end

    def method_missing(name, *_args, &_block)
      @_settings[name.to_sym] ||
        fail(NoMethodError, "unknown configuration root #{name}", caller)
    end
  end
end
