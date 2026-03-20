require "spec_helper"

describe Mavenlink::RateCardVersion, stub_requests: true, type: :model do
  it_should_behave_like "model", "rate_card_versions"

  describe "associations" do
    it { is_expected.to respond_to :rate_card }
    it { is_expected.to respond_to :rate_card_set_version }
    it { is_expected.to respond_to :rate_card_roles }
  end
end
