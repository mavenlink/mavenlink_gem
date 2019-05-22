require "spec_helper"

describe Mavenlink::Participation, stub_requests: true do
  describe "associations" do
    it { should respond_to "user" }
    it { should respond_to "workspace" }
    it { should respond_to "role" }
    it { should respond_to "workspace_resources" }
  end
end
