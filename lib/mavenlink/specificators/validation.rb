module Mavenlink
  module Specificators
    class Validation < Base

      # Defines attributes in model described in specification
      def apply
        (model_class.specification['validations'] || {}).each do |fields, options|
          model_class.validates(*fields, to_validation_options(options))
        end
      end

      private

      # Returns hash for validation options
      # @param options [Hash]
      # @return [Hash]
      def to_validation_options(options)
        options.tap do
          if options.is_a?(Hash)
            options.symbolize_keys!
            options.keys.each { |key| to_validation_options(options[key]) }
          end
        end
      end
    end
  end
end
