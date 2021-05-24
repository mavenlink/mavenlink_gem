require "spec_helper"

describe Mavenlink::EstimateScenarioResourceSkill, stub_requests: true, type: :model do
  it_should_behave_like "model", "estimate_scenario_resource_skills"

  describe "associations" do
    it { is_expected.to respond_to :skill }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :estimate_scenario_resource }
  end
end
