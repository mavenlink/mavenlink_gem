shared_examples_for Mavenlink::Submission do
  subject { described_class.new(id: 4) }
  let(:description) { "A submission description" }

  before do
    allow(subject.client).to receive(:put)
  end

  describe "#approve_submission" do
    it "uses a put method with the correct api endpoint and id" do
      expect(subject.client).to receive(:put).with("#{described_class.collection_name}/#{subject.id}/approve", resolution: { description: nil })
      subject.approve_submission
    end

    context "when a description is given" do
      it "adds the description to the request" do
        expect(subject.client).to receive(:put).with("#{described_class.collection_name}/#{subject.id}/approve", resolution: { description: description })
        subject.approve_submission(description)
      end
    end
  end

  describe "#cancel_submission" do
    it "uses a put method with the correct api endpoint and id" do
      expect(subject.client).to receive(:put).with("#{described_class.collection_name}/#{subject.id}/cancel", resolution: { description: nil })
      subject.cancel_submission
    end

    context "when a description is given" do
      it "adds the description to the request" do
        expect(subject.client).to receive(:put).with("#{described_class.collection_name}/#{subject.id}/cancel", resolution: { description: description })
        subject.cancel_submission(description)
      end
    end
  end

  describe "#reject_submission" do
    it "uses a put method with the correct api endpoint and id" do
      expect(subject.client).to receive(:put).with("#{described_class.collection_name}/#{subject.id}/reject", resolution: { description: nil })
      subject.reject_submission
    end

    context "when a description is given" do
      it "adds the description to the request" do
        expect(subject.client).to receive(:put).with("#{described_class.collection_name}/#{subject.id}/reject", resolution: { description: description })
        subject.reject_submission(description)
      end
    end
  end
end