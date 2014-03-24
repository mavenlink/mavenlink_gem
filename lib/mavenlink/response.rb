module Mavenlink
  class Response < BrainstemAdaptor::Response

    # @param response_data [String, Hash]
    # @param specification [BrainstemAdaptor::Specification]
    def initialize(response_data, specification = Mavenlink.specification)
      super
    end

    # Returns collection records
    # Wraps brainstem records into mavenlink models
    # @override
    # @return [Array<MavenLink::Model>]
    def results
      super.map { |record| Mavenlink::Model.models[record.collection_name].wrap(record) }
    end
  end
end