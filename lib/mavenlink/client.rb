module Mavenlink
  class Client
    ENDPOINT = "https://api.mavenlink.com/api/v1/".freeze
    TIMEOUT = 180

    # @param settings [ActiveSuppport::HashWithIndifferentAccess]
    def initialize(settings = Mavenlink.default_settings)
      @settings = settings
      (@oauth_token = settings[:oauth_token]) || raise(ArgumentError, "OAuth token is not set")
      @endpoint = settings[:endpoint] || ENDPOINT
      @use_json = settings[:use_json]
      @user_agent_override = settings[:user_agent_override] if settings.key?(:user_agent_override)

      # TODO: implement with method_missing?
      # Declare API calls client.-->>workspaces<<---.create({})
      Mavenlink.specification.keys.each do |collection_name|
        singleton_class.instance_eval do
          define_method collection_name do |args = {}|
            ::Mavenlink::Request.new("Mavenlink::#{collection_name.singularize.classify}".constantize.collection_path(**args), collection_name, self)
          end
        end
      end
    end

    # @return [Faraday::Connection]
    def connection
      Faraday.new(connection_options) do |builder|
        if @use_json
          builder.request :json
        else
          builder.use Faraday::Request::UrlEncoded
        end
        builder.adapter(*Mavenlink.adapter)
      end
    end

    def multipart_connection
      Faraday.new(connection_options) do |builder|
        builder.request :multipart
        builder.request :url_encoded
        builder.adapter(*Mavenlink.adapter)
      end
    end

    def me
      @me ||= Mavenlink::Response.new(get("users/me"), self, scope: {}, collection_name: "users")&.results&.first
    end

    # Performs custom GET request
    # @param [String] path
    # @param [Hash] arguments
    def get(path, arguments = {})
      Mavenlink.logger.note "Started GET /#{path} with #{arguments.inspect}"
      parse_request(connection.get(path, arguments))
    end

    # Performs custom POST request
    # @param [String] path
    # @param [Hash] arguments
    def post(path, arguments = {})
      Mavenlink.logger.note "Started POST /#{path} with #{arguments.inspect}"
      parse_request(connection.post(path, arguments))
    end

    # Performs custom POST request with multipart body
    # @param [String] path
    # @param [Hash] arguments
    def post_file(path, arguments = {})
      Mavenlink.logger.note "Started POST file /#{path} with #{arguments.inspect}"
      parse_request(multipart_connection.post(path, arguments))
    end

    # Performs custom PUT request
    # @param [String] path
    # @param [Hash] arguments
    def put(path, arguments = {})
      Mavenlink.logger.note "Started PUT /#{path} with #{arguments.inspect}"
      parse_request(connection.put(path, arguments))
    end

    # Performs custom PUT request
    # @param [String] path
    # @param [Hash] arguments
    def delete(path, arguments = {})
      Mavenlink.logger.note "Started DELETE /#{path} with #{arguments.inspect}"
      parse_request(connection.delete(path, arguments))
    end

    private

    attr_reader :oauth_token, :endpoint

    # @return [Hash]
    def connection_options
      user_agent = if @user_agent_override && @user_agent_override.length > 1
                     @user_agent_override.to_s
                   else
                     "Mavenlink Ruby Gem"
                   end
      {
        headers: { "Accept" => "application/json",
                   "User-Agent" => user_agent.to_s,
                   "Authorization" => "Bearer #{oauth_token}" },
        ssl: { verify: false },
        url: endpoint,
        request: { timeout: TIMEOUT }
      }.freeze
    end

    def parse_request(response)
      return unless response.body.present?

      parsed_response = JSON.parse(response.body)
      status = response.status

      parsed_response.tap do
        Mavenlink.logger.whisper "Received response:"
        Mavenlink.logger.inspection response

        case parsed_response
        when Array
          Mavenlink.logger.whisper "Returned as a plain collection"
        when Hash
          raise_invalid_request_error(parsed_response, status) if errored_response?(parsed_response)
        end
      end
    rescue JSON::ParserError => e
      raise Mavenlink::InvalidResponseError, e.message
    end

    def raise_invalid_request_error(parsed_response, status)
      Mavenlink.logger.disappointment "REQUEST FAILED:"
      Mavenlink.logger.inspection parsed_response["errors"] || parsed_response["error_message"]
      raise InvalidRequestError, parsed_response.merge("status" => status)
    end

    def errored_response?(parsed_response)
      parsed_response["errors"] || parsed_response["error_message"]
    end
  end
end
