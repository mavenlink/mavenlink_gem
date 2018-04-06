require "spec_helper"

describe Mavenlink::AccountMembership, stub_requests: true do
  describe "associations" do
    it { should respond_to "cost_rates" }
  end
end
