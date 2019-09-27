require "spec_helper"

describe Mavenlink::ExpenseReportSubmission, stub_requests: true, type: :model do
  let(:report) { described_class.new(id: 4) }

  describe "#approve_submission" do
    before do
      allow(report.client).to receive(:put)
      report.approve_submission
    end

    it "uses a put method with the correct api endpoint and id" do
      expect(report.client).to have_received(:put).with("expense_report_submissions/4/approve")
    end
  end

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
