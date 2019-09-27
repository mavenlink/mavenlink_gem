require "spec_helper"

describe Mavenlink::Participation, stub_requests: true do
  describe "associations" do
    it { is_expected.to respond_to "user" }
    it { is_expected.to respond_to "workspace" }
    it { is_expected.to respond_to "role" }
    it { is_expected.to respond_to "workspace_resources" }
  end
end
