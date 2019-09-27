module Mavenlink
  module Concerns
    module LockedRecord
      include Indestructible
      extend ActiveSupport::Concern

      included do
        class << self
          protected :new
          protected :create
        end
      end

      # @overload
      def save
        raise RecordLockedError, "The model is locked and cannot be changed"
      end

      # @overload
      def new_record?
        false
      end

      # @overload
      def persisted?
        true
      end
    end
  end
end
