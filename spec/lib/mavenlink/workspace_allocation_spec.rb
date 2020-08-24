require "spec_helper"

describe Mavenlink::WorkspaceAllocation, stub_requests: true, type: :model do
  it_should_behave_like "model", "workspace_allocations"

  describe "validations" do
    it { is_expected.to validate_presence_of "resource_id" }
    it { is_expected.to validate_presence_of "start_date" }
    it { is_expected.to validate_presence_of "end_date" }
    it { is_expected.to validate_presence_of "minutes" }
  end

  describe "associations" do
    it { is_expected.to respond_to "workspace_resource" }
    it { is_expected.to respond_to "workspace" }
    it { is_expected.to respond_to "creator" }
    it { is_expected.to respond_to "updater" }
    it { is_expected.to respond_to "external_references" }
  end
end
