module Mavenlink
  class ExchangeTable < Model
    def self.collection_path(_ = {})
      "foreign_exchange/exchange_tables"
    end
  end
end
