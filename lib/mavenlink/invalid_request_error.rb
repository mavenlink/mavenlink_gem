module Mavenlink
  class InvalidRequestError < Mavenlink::Error
    attr_reader :request

    # @param request [Mavenlink::Request]
    # @param message [Stirng]
    def initialize(request, message = request.inspect)
      @request = request
      super(message)
    end
  end
end