require "spec_helper"

describe Mavenlink::EstimateScenario, stub_requests: true, type: :model do
  it_should_behave_like "model", "estimate_scenarios"

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :start_date }
  end

  describe "associations" do
    it { is_expected.to respond_to :rate_card }
    it { is_expected.to respond_to :estimate_scenario_resources }
  end
end
