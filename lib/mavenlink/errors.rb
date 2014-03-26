module Mavenlink

  # The most generic MavenlinkAPI error
  # Eg. service unavailable etc...
  class Error < StandardError
  end

  # Another generic API error idenfitying that request is invalid.
  # Eg. invalid parameters passsed in request.
  class InvalidRequestError < Error
    attr_reader :request

    # @param request [Mavenlink::Request]
    # @param message [Stirng]
    def initialize(request, message = request.inspect)
      @request = request
      super(message)
    end
  end

  # Identified that a record cannot be changed.
  # Eg. cannot be saved, removed etc.
  class RecordLockedError < Error
  end

  # Raised when user is attmping to find unexisting record.
  # Eg. user updates record while somebody else already removed this record.
  class RecordNotFoundError < InvalidRequestError
  end

  # Raised when user is trying to save! record specifying invalid attributes.
  # Eg. create! workspace without title.
  class RecordInvalidError < Error
    attr_reader :record # :nodoc:

    # @param record [Mavenlink::Model]
    def initialize(record)
      @record = record
      super(@record.errors.full_messages.join(", "))
    end
  end
end
