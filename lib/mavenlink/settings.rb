module Mavenlink
  class Settings < ActiveSupport::HashWithIndifferentAccess
    DEFAULTS = { perform_validations: false }.freeze

    def self.[](key)
      (@instances ||= {})[key] ||= new.tap do |defaults|
        defaults.merge!(DEFAULTS)
      end
    end
  end
end
