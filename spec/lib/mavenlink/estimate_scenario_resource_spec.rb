require "spec_helper"

describe Mavenlink::EstimateScenarioResource, stub_requests: true, type: :model do
  it_should_behave_like "model", "estimate_scenario_resources"

  describe "associations" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :role }
    it { is_expected.to respond_to :organization_membership }
    it { is_expected.to respond_to :allocation }
    it { is_expected.to respond_to :geography }
    it { is_expected.to respond_to :skills }
    it { is_expected.to respond_to :estimate_scenario_resource_skills }
  end
end
