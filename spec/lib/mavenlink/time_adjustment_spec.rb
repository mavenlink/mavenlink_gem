require "spec_helper"

describe Mavenlink::TimeAdjustment, stub_requests: true, type: :model do
  it_should_behave_like "model", "time_adjustments"

  describe "associations" do
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :active_invoice }
    it { is_expected.to respond_to :external_references }
  end
end
