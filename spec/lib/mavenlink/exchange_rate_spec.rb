require "spec_helper"

describe Mavenlink::ExchangeRate, stub_requests: true, type: :model do
  describe ".collection_path" do
    let(:exchange_table_id) { "1111" }

    it "raises an ArgumentError if exchange_table_id is missing" do
      expect { described_class.collection_path }.to raise_error(ArgumentError)
    end

    it "returns a formatted path with the given exchange_table_id" do
      expect(described_class.collection_path(exchange_table_id: exchange_table_id)).to eq(
        "foreign_exchange/exchange_tables/#{exchange_table_id}/rates"
      )
    end
  end
end
