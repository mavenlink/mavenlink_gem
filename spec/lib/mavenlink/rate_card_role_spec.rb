require "spec_helper"

describe Mavenlink::RateCardRole, stub_requests: true, type: :model do
  it_should_behave_like "model", "rate_card_roles"

  describe "associations" do
    it { is_expected.to respond_to :role }
    it { is_expected.to respond_to :rate_card_version }
  end
end
