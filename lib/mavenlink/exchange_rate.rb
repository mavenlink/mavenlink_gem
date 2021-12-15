module Mavenlink
  class ExchangeRate < Model
    def self.collection_path(args = {})
      raise ArgumentError, "exchange_table_id must be set" if args[:exchange_table_id].blank?

      "foreign_exchange/exchange_tables/#{args[:exchange_table_id]}/rates"
    end
  end
end
