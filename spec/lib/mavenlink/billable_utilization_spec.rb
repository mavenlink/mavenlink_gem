require "spec_helper"

describe Mavenlink::BillableUtilization, stub_requests: true, type: :model do
  it_should_behave_like "model", "billable_utilizations"

  describe "association" do
    it { is_expected.to respond_to :account_membership }
  end
end
