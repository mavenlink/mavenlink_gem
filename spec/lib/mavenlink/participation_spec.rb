require "spec_helper"

describe Mavenlink::Participation, stub_requests: true, type: :model do
  describe "associations" do
    it { is_expected.to respond_to "user" }
    it { is_expected.to respond_to "workspace" }
    it { is_expected.to respond_to "workspace_role" }
    it { is_expected.to respond_to "primary_role" }
    it { is_expected.to respond_to "workspace_resources" }
    it { is_expected.to respond_to "active_roles" }
  end
end
