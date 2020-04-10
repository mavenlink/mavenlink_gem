require "spec_helper"

describe Mavenlink::WorkspaceResourceSkill, stub_requests: true do
  it_should_behave_like "model", "workspace_resource_skills"

  describe "associations" do
    it { is_expected.to respond_to "skill" }
    it { is_expected.to respond_to "creator" }
    it { is_expected.to respond_to "workspace_resource" }
  end
end
