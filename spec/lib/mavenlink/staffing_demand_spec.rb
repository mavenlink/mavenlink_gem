require "spec_helper"

describe Mavenlink::StaffingDemand, stub_requests: true, type: :model do
  it_should_behave_like "model", "staffing_demands"

  describe "association" do
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :owner }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :role }
    it { is_expected.to respond_to :skills }
    it { is_expected.to respond_to :staffing_demand_skills }
    it { is_expected.to respond_to :custom_field_values }
  end
end
