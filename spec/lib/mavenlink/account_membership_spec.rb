require "spec_helper"

describe Mavenlink::AccountMembership, stub_requests: true do
  describe "associations" do
    it { should respond_to "user" }
    it { should respond_to "default_role" }
    it { should respond_to "effective_workweek" }
    it { should respond_to "possible_managers" }
    it { should respond_to "manager" }
    it { should respond_to "user" }
    it { should respond_to "possible_managees" }
    it { should respond_to "managees" }
    it { should respond_to "skill_memberships" }
    it { should respond_to "backup_approver_associations" }
    it { should respond_to "cost_rates" }
    it { should respond_to "future_billable_utilizations" }
  end
end
