module Mavenlink
  class Settings < ActiveSupport::HashWithIndifferentAccess
    DEFAULTS = {enable_validations: false}.freeze

    def self.[](key)
      (@instances ||= {})[key] ||= self.new.tap do |defaults|
        defaults.merge!(DEFAULTS)
      end
    end
  end
end