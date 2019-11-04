module Mavenlink
  module Specificators
    # Specificator is used to inject anything described in specification file into your model.
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
        new(model_class).apply
      end
    end
  end
end
