require "spec_helper"

describe Mavenlink::RateCardSetVersion, stub_requests: true do
	subject { described_class.new(id: "7", rate_card_set_id: "1") }
  let(:client) { double(Mavenlink::Client) }

  describe "#publish" do
    context "when the publish is successful" do
      let(:publish_response) { { "activated" => true } }

      before do
        allow(subject).to receive(:persisted?) { true }
        stub_request :put, "/api/v1/rate_card_set_versions/7/publish", publish_response
      end

      it "returns true" do
        expect(subject.publish).to eq(true)
      end
    end

    context "when the publish fails" do
      before do
        allow(subject).to receive(:client) { client }
        allow(client).to receive(:put).and_raise(Faraday::Error)
      end

      it "returns false" do
        expect(subject.publish).to eq(false)
      end
    end

    context "when the record is not persisted" do
      before do
        allow(subject).to receive(:persisted?) { false }
      end

      it "returns false" do
        expect(subject.publish).to eq(false)
      end
    end
  end

  describe "#clone" do
    context "when `clone` is successful" do
      let(:clone_response) { {
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
      } }

      before do
        stub_request :post, "/api/v1/rate_card_set_versions", clone_response
      end

      it "returns the new rate card set version" do
        expect_any_instance_of(Mavenlink::Client).to receive(:post).with("rate_card_set_versions",
                                                                         clone_id: subject.id,
                                                                         rate_card_set_versions: {
                                                                           rate_card_set_id: subject.rate_card_set_id,
                                                                           effective_date: nil
                                                                         }).and_call_original
        expect(subject.clone_version).to eq(described_class.new(id: "8", effective_date: "2018-09-04", rate_card_set_id: "1"))
      end

      it "sends the effective_date parameter" do
        date = Date.new(2018, 9, 5)
        expect_any_instance_of(Mavenlink::Client).to receive(:post).with("rate_card_set_versions",
                                                                         clone_id: subject.id,
                                                                         rate_card_set_versions: {
                                                                           rate_card_set_id: subject.rate_card_set_id,
                                                                           effective_date: date
                                                                         }).and_call_original
        subject.clone_version(date)
      end
    end

    context "when `clone` is not successful" do
      context "when the response is an error" do
        let(:clone_response) { {
          "errors" => [
            {
              "type" => "system",
              "message" => "not found"
            }
          ],
        } }

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
