module Mavenlink
  class ExchangeTable < Model
    def self.collection_path(_ = {})
      "foreign_exchange/exchange_tables"
    end

    # NOTE: The API response is currently bugged. It returns results with an incorrect key
    #   "exchange_rate" should be plural "exchange_rates" to satisfy brainstem requirements.
    #
    #   To get around this bug we need to manually initialize the exchange rate objects returned.
    #   Ideally we should be able to just call `results` on the response and have this be handles automatically.
    def rates(filters = {})
      response = request.perform { client.get("#{self.class.collection_path}/#{id}/rates", filters) }

      response.response_data["exchange_rates"].values.map do |exchange_rate_attributes|
        Mavenlink::ExchangeRate.new(exchange_rate_attributes, nil, client)
      end
    end
  end
end
