require "spec_helper"

describe Mavenlink::AccessGroup, stub_requests: true do
  describe "associations" do
    it { should respond_to "last_updated_user" }
    it { should respond_to "users" }
  end
end
