require "spec_helper"

describe Mavenlink::ExpenseReportSubmission, stub_requests: true, type: :model do
  it_behaves_like Mavenlink::Submission
end
