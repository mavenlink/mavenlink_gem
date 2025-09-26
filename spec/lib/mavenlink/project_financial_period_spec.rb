require "spec_helper"

describe Mavenlink::ProjectFinancialPeriod, stub_requests: true, type: :model do
  it_should_behave_like "model", "project_financial_periods"

  describe "associations" do
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :financial_period }
  end
end
