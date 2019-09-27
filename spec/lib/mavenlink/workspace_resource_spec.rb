require "spec_helper"

describe Mavenlink::WorkspaceResource, stub_requests: true do
  it_should_behave_like "model", "workspace_resources"

  describe "validations" do
    it { is_expected.to validate_presence_of "workspace_id" }
  end

  describe "associations" do
    it { is_expected.to respond_to "participation" }
    it { is_expected.to respond_to "user" }
    it { is_expected.to respond_to "role" }
    it { is_expected.to respond_to "skills" }
    it { is_expected.to respond_to "workspace" }
  end
end
