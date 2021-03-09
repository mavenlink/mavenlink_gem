require "spec_helper"

describe Mavenlink::Candidate, stub_requests: true, type: :model do
  it_should_behave_like "model", "candidates"

  describe "association" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :staffing_demand }
    it { is_expected.to respond_to :custom_field_values }
    it { is_expected.to respond_to :external_references }
  end
end
