module Mavenlink
  class Client
    ENDPOINT = 'https://api.mavenlink.com/api/v1/'.freeze

    # @param settings [ActiveSuppport::HashWithIndifferentAccess]
    def initialize(settings = Mavenlink.default_settings)
      @settings = settings
      @oauth_token = settings[:oauth_token] or raise ArgumentError, 'OAuth token is not set'

      # TODO: implement with method_missing?
      # Declare API calls client.-->>workspaces<<---.create({})
      Mavenlink.specification.keys.each do |collection_name|
        singleton_class.instance_eval do
          define_method collection_name do
            ::Mavenlink::Request.new(collection_name, self)
          end
        end
      end
    end

    # @return [Faraday::Connection]
    def connection
      Faraday.new(connection_options) do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::ParseJson

        builder.adapter(*Mavenlink.adapter)
      end
    end

    # Performs custom GET request
    # @param [String] path
    # @param [Hash] arguments
    def get(path, arguments = {})
      Mavenlink.logger.note "Started GET /#{path} with #{arguments.inspect}"
      perform_request { connection.get(path, arguments).body }
    end

    # Performs custom POST request
    # @param [String] path
    # @param [Hash] arguments
    def post(path, arguments = {})
      Mavenlink.logger.note "Started POST /#{path} with #{arguments.inspect}"
      perform_request { connection.post(path, arguments).body }
    end

    # Performs custom PUT request
    # @param [String] path
    # @param [Hash] arguments
    def put(path, arguments = {})
      Mavenlink.logger.note "Started PUT /#{path} with #{arguments.inspect}"
      perform_request { connection.put(path, arguments).body }
    end

    # Performs custom PUT request
    # @param [String] path
    # @param [Hash] arguments
    def delete(path, arguments = {})
      Mavenlink.logger.note "Started DELETE /#{path} with #{arguments.inspect}"
      perform_request { connection.delete(path, arguments).body }
    end

    private

    # @return [Hash]
    def connection_options
      {
        headers: { 'Accept'        => "application/json",
                   'User-Agent'    => "Mavenlink",
                   'Authorization' => "Bearer #@oauth_token" },
        ssl: { verify: false },
        url: ENDPOINT
      }.freeze
    end

    def perform_request
      yield.tap do |response|
        if response['errors']
          Mavenlink.logger.disappointment 'REQUEST FAILED:'
          Mavenlink.logger.inspection response['errors']
          raise InvalidRequestError.new(response)
        else
          Mavenlink.logger.whisper 'Received response:'
          Mavenlink.logger.inspection response
        end
      end
    rescue Faraday::Error::ParsingError => e
      raise Mavenlink::InvalidResponseError.new(e.message)
    end
  end
end
