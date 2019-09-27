require 'mavenlink'
require 'shoulda/matchers/active_model'
require 'awesome_print'
require 'support/shared_examples'

shared_context 'stubbed requests', stub_requests: true do
  let(:stubbed_requests) do
    Faraday::Adapter::Test::Stubs.new
  end

  before do
    Mavenlink.oauth_token = 'token'
    Mavenlink.adapter = [:test, stubbed_requests]
  end

  def stub_request(request_type, path, response)
    stubbed_requests.public_send(request_type, path) { [200, {}, response.to_json] }
  end
end

Mavenlink.perform_validations = true
Mavenlink.logger = Mavenlink::Logger.new(STDOUT)
Mavenlink.logger.level = Logger::INFO

RSpec.configure do |config|
  config.mock_with :rspec
  config.color = true
  config.formatter = :documentation
  config.include Shoulda::Matchers::ActiveModel
  config.extend Shoulda::Matchers::ActiveModel
end
