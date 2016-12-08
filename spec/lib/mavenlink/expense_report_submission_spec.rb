require 'spec_helper'

describe Mavenlink::ExpenseReportSubmission, stub_requests: true do
  let(:report) { described_class.new(id: 4) }

  describe "#reject_submission" do
    before do
      allow(report.client).to receive(:put)
      report.reject_submission
    end

    it "uses a put method with the correct api endpoint and id" do
      expect(report.client).to have_received(:put).with("expense_report_submissions/4/reject")
    end
  end
end
