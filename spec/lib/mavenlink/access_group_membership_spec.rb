require "spec_helper"

describe Mavenlink::AccessGroupMembership, stub_requests: true, type: :model do
  describe "associations" do
    it { is_expected.to respond_to "access_group" }
    it { is_expected.to respond_to "user" }
  end
end
