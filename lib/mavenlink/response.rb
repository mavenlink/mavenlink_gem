module Mavenlink
  class Response < BrainstemAdaptor::Response
    attr_reader :client, :scope

    # @param response_data [String, Hash]
    # @param specification [BrainstemAdaptor::Specification]
    # @param client [Mavenlink::Client]
    def initialize(response_data, client = Mavenlink.client, specification = Mavenlink.specification, scope: {})
      @client = client
      @scope = scope
      super(response_data, specification)
    end

    # Returns collection records
    # Wraps brainstem records into mavenlink models
    # @override
    # @return [Array<MavenLink::Model>]
    def results
      super.map { |record| Mavenlink::Model.models[record.collection_name].wrap(record, client, scope) }
    end
  end
end
