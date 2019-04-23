require "spec_helper"

describe Mavenlink::WorkspaceAllocation, stub_requests: true do
  it_should_behave_like "model", "workspace_allocations"

  describe "validations" do
    it { should validate_presence_of "resource_id" }
    it { should validate_presence_of "start_date" }
    it { should validate_presence_of "end_date" }
    it { should validate_presence_of "minutes" }
  end

  describe "associations" do
    it { should respond_to "workspace_resource" }
    it { should respond_to "workspace" }
  end
end
