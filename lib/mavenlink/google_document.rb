module Mavenlink
  class GoogleDocument < Model
    include Concerns::Indestructible

    protected

    def update
      raise RecordLockedError, 'The model is locked and cannot be changed'
    end
  end
end