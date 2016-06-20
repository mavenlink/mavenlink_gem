module Mavenlink
  class Client
    ENDPOINT = 'https://api.mavenlink.com/api/v1/'.freeze

    # @param settings [ActiveSuppport::HashWithIndifferentAccess]
    def initialize(settings = Mavenlink.default_settings)
      @settings = settings
      @oauth_token = settings[:oauth_token] or raise ArgumentError, 'OAuth token is not set'
      @endpoint = settings[:endpoint] || ENDPOINT

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
        builder.adapter(*Mavenlink.adapter)
      end
    end

    # Performs custom GET request
    # @param [String] path
    # @param [Hash] arguments
    def get(path, arguments = {})
      Mavenlink.logger.note "Started GET /#{path} with #{arguments.inspect}"
      parse_request(connection.get(path, arguments).body)
    end

    # Performs custom POST request
    # @param [String] path
    # @param [Hash] arguments
    def post(path, arguments = {})
      Mavenlink.logger.note "Started POST /#{path} with #{arguments.inspect}"
      parse_request(connection.post(path, arguments).body)
    end

    # Performs custom PUT request
    # @param [String] path
    # @param [Hash] arguments
    def put(path, arguments = {})
      Mavenlink.logger.note "Started PUT /#{path} with #{arguments.inspect}"
      parse_request(connection.put(path, arguments).body)
    end

    # Performs custom PUT request
    # @param [String] path
    # @param [Hash] arguments
    def delete(path, arguments = {})
      Mavenlink.logger.note "Started DELETE /#{path} with #{arguments.inspect}"
      parse_request(connection.delete(path, arguments).body)
    end

    # @note(AC): would you consider this to be inconsistent?
    # @return [Array<String>]
    def expense_categories
      Mavenlink.logger.note 'Started GET /expense_categories'
      parse_request(connection.get('expense_categories').body)
    end

    private

    attr_reader :oauth_token, :endpoint

    # @return [Hash]
    def connection_options
      {
        headers: { 'Accept'        => "application/json",
                   'User-Agent'    => "Mavenlink Ruby Gem",
                   'Authorization' => "Bearer #{oauth_token}" },
        ssl: { verify: false },
        url: endpoint
      }.freeze
    end

    def parse_request(response)
      if response.present?
        parsed_response = JSON.parse(response)
      else
        return
      end

      parsed_response.tap do
        Mavenlink.logger.whisper 'Received response:'
        Mavenlink.logger.inspection response

        case parsed_response
        when Array
          Mavenlink.logger.whisper 'Returned as a plain collection'
        when Hash
          if parsed_response['errors']
            Mavenlink.logger.disappointment 'REQUEST FAILED:'
            Mavenlink.logger.inspection parsed_response['errors']
            raise InvalidRequestError.new(parsed_response)
          end
        end
      end
    rescue JSON::ParserError => e
      raise Mavenlink::InvalidResponseError.new(e.message)
    end
  end
end
