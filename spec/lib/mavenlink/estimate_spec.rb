require "spec_helper"

describe Mavenlink::Estimate, stub_requests: true, type: :model do
  it_should_behave_like "model", "estimates"

  describe "associations" do
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :workspace_group }
    it { is_expected.to respond_to :estimate_scenarios }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :custom_field_values }
    it { is_expected.to respond_to :favorite_scenario }
  end
end
