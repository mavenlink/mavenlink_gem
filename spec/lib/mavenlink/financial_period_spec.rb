require "spec_helper"

describe Mavenlink::FinancialPeriod, stub_requests: true, type: :model do
  it_should_behave_like "model", "financial_periods"
end
