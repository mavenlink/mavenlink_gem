require "spec_helper"

describe Mavenlink::AccountMembership, stub_requests: true, type: :model do
  describe "associations" do
    it { is_expected.to respond_to "user" }
    it { is_expected.to respond_to "default_role" }
    it { is_expected.to respond_to "effective_workweek" }
    it { is_expected.to respond_to "possible_managers" }
    it { is_expected.to respond_to "manager" }
    it { is_expected.to respond_to "user" }
    it { is_expected.to respond_to "possible_managees" }
    it { is_expected.to respond_to "managees" }
    it { is_expected.to respond_to "skill_memberships" }
    it { is_expected.to respond_to "backup_approver_associations" }
    it { is_expected.to respond_to "cost_rates" }
    it { is_expected.to respond_to "future_billable_utilizations" }
  end
end
