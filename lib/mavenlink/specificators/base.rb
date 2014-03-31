module Mavenlink
  module Specificators
    class Base
      attr_reader :model_class

      # @param model_class [Class]
      def initialize(model_class)
        @model_class = model_class
      end

      # Injects things described in specification file into the model
      def apply
        raise NotImplementedError
      end

      # @param model_class [Class]
      def self.apply(model_class)
        self.new(model_class).apply
      end
    end
  end
end