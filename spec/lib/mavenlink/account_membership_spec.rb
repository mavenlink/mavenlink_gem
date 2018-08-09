require "spec_helper"

describe Mavenlink::AccountMembership, stub_requests: true do
  describe "associations" do
    it { should respond_to "cost_rates" }
    it { should respond_to "backup_approver_associations" }
  end
end
