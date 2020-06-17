require "spec_helper"

describe Mavenlink::ScheduledJobs::InsightsReportExport, stub_requests: true, type: :model do
  describe "#latest" do
    before do
      allow(subject).to receive(:persisted?) { true }
    end

    it "makes a call to get the latest report" do
      expect_any_instance_of(Mavenlink::Client).to receive(:get).with("#{subject.collection_name}/#{subject.id}/results/latest")
      subject.latest
    end

    context "when the record is not persisted" do
      before do
        allow(subject).to receive(:persisted?) { false }
      end

      it "raises an error" do
        expect { subject.latest }.to raise_error(Mavenlink::RecordInvalidError)
      end
    end
  end
end
