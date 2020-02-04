require "spec_helper"

describe Mavenlink::RateCardSetVersion, stub_requests: true, type: :model do
  subject { described_class.new(id: "7", rate_card_set_id: "1") }

  describe "#publish!" do
    before do
      allow(subject).to receive(:persisted?) { true }
    end

    context "when the record is not persisted" do
      before do
        allow(subject).to receive(:persisted?) { false }
      end

      it "raises an error" do
        expect { subject.publish! }.to raise_error(Mavenlink::Error, "Record not defined")
      end
    end

    it "makes a put to the rate card set versions publish endpoint" do
      expect_any_instance_of(Mavenlink::Client).to receive(:put).with("rate_card_set_versions/#{subject.id}/publish")
      subject.publish!
    end
  end

  describe "#clone" do
    context "when `clone` is successful" do
      let(:clone_response) do
        {
          "count" => 1,
          "results" => [
            {
              "key" => "rate_card_set_versions",
              "id" => "8"
            }
          ],
          "rate_card_set_versions" => {
            "8" => {
              "id" => "8",
              "effective_date" => "2018-09-04",
              "rate_card_set_id" => "1"
            }
          }
        }
      end

      before do
        stub_request :post, "/api/v1/rate_card_set_versions", clone_response
      end

      it "returns the new rate card set version" do
        expect_any_instance_of(Mavenlink::Client).to receive(:post).with(
          "rate_card_set_versions",
          clone_id: subject.id,
          rate_card_set_version: {
            rate_card_set_id: subject.rate_card_set_id,
            effective_date: nil
          }
        ).and_call_original
        expect(subject.clone_version).to eq(described_class.new(id: "8", effective_date: "2018-09-04", rate_card_set_id: "1"))
      end

      it "sends the effective_date parameter" do
        date = Date.new(2018, 9, 5)
        expect_any_instance_of(Mavenlink::Client).to receive(:post).with(
          "rate_card_set_versions",
          clone_id: subject.id,
          rate_card_set_version: {
            rate_card_set_id: subject.rate_card_set_id,
            effective_date: date
          }
        ).and_call_original
        subject.clone_version(date)
      end
    end

    context "when `clone` is not successful" do
      context "when the response is an error" do
        let(:clone_response) do
          {
            "errors" => [
              {
                "type" => "system",
                "message" => "not found"
              }
            ]
          }
        end

        before do
          stub_request :post, "/api/v1/rate_card_set_versions", clone_response
        end

        it "returns false" do
          expect(subject.clone_version).to eq(false)
        end
      end

      context "when the record is not persisted" do
        before do
          allow(subject).to receive(:persisted?) { false }
        end

        it "returns false" do
          expect(subject.clone_version).to eq(false)
        end
      end
    end
  end
end
