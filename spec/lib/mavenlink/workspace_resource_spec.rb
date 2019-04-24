require "spec_helper"

describe Mavenlink::WorkspaceResource, stub_requests: true do
  it_should_behave_like "model", "workspace_resources"

  describe "validations" do
    it { should validate_presence_of "workspace_id" }
  end

  describe "associations" do
    it { should respond_to "participation" }
    it { should respond_to "user" }
    it { should respond_to "role" }
    it { should respond_to "skills" }
    it { should respond_to "workspace" }
  end
end
