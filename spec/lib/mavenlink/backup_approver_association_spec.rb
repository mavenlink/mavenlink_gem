require "spec_helper"

describe Mavenlink::BackupApproverAssociation, stub_requests: true do
  it_should_behave_like "model", "backup_approver_associations"

  describe "association" do
    it { should respond_to :account_membership }
  end
end
