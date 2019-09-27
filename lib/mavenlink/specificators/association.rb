module Mavenlink
  module Specificators
    class Association < Base
      # Defines attributes in model described in specification
      def apply
        (model_class.specification["associations"] || {}).keys.each do |association_name|
          model_class.association association_name
        end
      end
    end
  end
end
