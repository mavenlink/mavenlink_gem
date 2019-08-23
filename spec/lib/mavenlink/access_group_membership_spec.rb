require "spec_helper"

describe Mavenlink::AccessGroupMembership, stub_requests: true do
  describe "associations" do
    it { should respond_to "access_group" }
    it { should respond_to "user" }
  end
end
