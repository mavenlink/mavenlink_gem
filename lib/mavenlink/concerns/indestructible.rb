module Mavenlink
  module Concerns
    module Indestructible

      # @overload
      def destroy
        raise RecordLockedError, 'The model is locked and cannot be deleted'
      end
    end
  end
end