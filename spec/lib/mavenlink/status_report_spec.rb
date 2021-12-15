require "spec_helper"

describe Mavenlink::StatusReport, stub_requests: true, type: :model do
  it_should_behave_like "model", "status_reports"

  describe "associations" do
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :external_references }
  end
end
