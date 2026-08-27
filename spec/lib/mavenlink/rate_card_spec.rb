require "spec_helper"

describe Mavenlink::RateCard, stub_requests: true, type: :model do
  it_should_behave_like "model", "rate_cards"

  describe "associations" do
    it { is_expected.to respond_to :rate_card_set }
    it { is_expected.to respond_to :rate_card_versions }
    it { is_expected.to respond_to :effective_rate_card_version }
    it { is_expected.to respond_to :external_references }
  end
end
