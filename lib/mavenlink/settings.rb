module Mavenlink
  class Settings < ActiveSupport::HashWithIndifferentAccess
    def self.[](key)
      (@instances ||= {})[key] ||= self.new
    end
  end
end