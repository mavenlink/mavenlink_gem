require "spec_helper"

describe Mavenlink::ExchangeTable, stub_requests: true, type: :model do
  subject(:exchange_table) { described_class.new(id: "1111") }

  let(:client) { double(Mavenlink::Client) }

  it_should_behave_like "model", "exchange_tables"

  describe ".collection_path" do
    it "has a custom collection_path" do
      expect(described_class.collection_path).to eq "foreign_exchange/exchange_tables"
    end
  end

  describe "#rates" do
    let(:path) { "#{described_class.collection_path}/#{exchange_table.id}/rates" }
    let(:filters) { { date: "2021-09-24" } }
    let(:exchange_rate_id) { "2222" }
    let(:response) do
      {
        "count" => 1,
        "results" => [
          {
            "key" => "exchange_rate",
            "id" => exchange_rate_id
          }
        ],
        "exchange_rates" => {
          exchange_rate_id => {
            "id" => exchange_rate_id,
            "exchange_table_id" => exchange_table.id,
            "source_currency" => "USD",
            "target_currency" => "EUR",
            "effective_date" => "2020-01-01",
            "rate" => 0.85,
            "source_currency_symbol" => "$"
          }
        }
      }
    end

    it "fetches exchange rates with the given filters and returns a mavenlink object for each result" do
      expect_any_instance_of(Mavenlink::Client).to receive(:get).with(path, filters) { response }
      expect(exchange_table.rates(filters)).to match_array(an_instance_of(Mavenlink::ExchangeRate).and having_attributes(response["exchange_rates"][exchange_rate_id]))
    end
  end
end
