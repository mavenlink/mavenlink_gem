module Mavenlink
  module Specificators
    class Attribute < Base

      # Defines attributes in model described in specification
      def apply
        (model_class.available_attributes).each do |attr|
          model_class.attribute attr
        end
      end
    end
  end
end