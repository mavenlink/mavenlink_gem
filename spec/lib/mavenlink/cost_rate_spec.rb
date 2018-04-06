require "spec_helper"

describe Mavenlink::CostRate, stub_requests: true do
  it_should_behave_like "model", "cost_rates"

  describe "association" do
    it { should respond_to :account_membership }
  end
end
