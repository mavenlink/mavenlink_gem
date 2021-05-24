require "spec_helper"

describe Mavenlink::EstimateScenarioResourceAllocation, stub_requests: true, type: :model do
  it_should_behave_like "model", "estimate_scenario_resource_allocations"

  describe "associations" do
    it { is_expected.to respond_to :resource }
  end
end
