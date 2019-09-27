require "spec_helper"

describe Mavenlink::AccessGroup, stub_requests: true do
  describe "associations" do
    it { is_expected.to respond_to "last_updated_user" }
    it { is_expected.to respond_to "users" }
  end
end
