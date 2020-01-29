require "spec_helper"

describe Mavenlink::RateCardSet, stub_requests: true, type: :model do
  subject { described_class.new(id: "7") }
  let(:client) { double(Mavenlink::Client) }
  let(:rate_card_set_id) { "9" }
  let(:rate_card_set_title) { "Rate Card Set Title" }

  describe "#clone!" do
    let(:rate_card_set_version_id) { 10 }

    context "when `clone!` is successful" do
      let(:clone_response) do
        {
          "count" => 1,
          "results" => [
            {
              "key" => "rate_card_sets",
              "id" => rate_card_set_id
            }
          ],
          "rate_card_sets" => {
            rate_card_set_id => {
              "id" => rate_card_set_id,
              "title" => "Copy of #{rate_card_set_title}"
            }
          }
        }
      end

      before do
        stub_request :post, "/api/v1/rate_card_sets", clone_response
      end

      it "returns the new rate card set" do
        expect_any_instance_of(Mavenlink::Client).to receive(:post).with(
          "rate_card_sets",
          clone_version_id: rate_card_set_version_id,
          include: nil,
          rate_card_set: {
            title: nil
          }).and_call_original

        expect(subject.clone!(rate_card_set_version_id)).to eq(described_class.new(id: rate_card_set_id, title: "Copy of #{rate_card_set_title}"))
      end

      it "sends the title and include parameter" do
        title = "A New Rate Card Set Title"
        include = :rate_card_set_versions
        expect_any_instance_of(Mavenlink::Client).to receive(:post).with(
          "rate_card_sets",
          clone_version_id: rate_card_set_version_id,
          include: include,
          rate_card_set: {
            title: title
          }).and_call_original

        subject.clone!(rate_card_set_version_id, title: title, include: include)
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
          stub_request :post, "/api/v1/rate_card_sets", clone_response
        end

        it "raises an error" do
          expect { subject.clone!(rate_card_set_version_id) }.to raise_error(Mavenlink::Error)
        end
      end

      context "when the record is not persisted" do
        before do
          allow(subject).to receive(:persisted?) { false }
        end

        it "raises an error" do
          expect { subject.clone!(rate_card_set_version_id) }.to raise_error(Mavenlink::Error)
        end
      end
    end
  end

  describe "#clone" do
    let(:rate_card_set_version_id) { 10 }

    it "calls the #clone! method" do
      expect(subject).to receive(:clone!).with(rate_card_set_version_id, title: rate_card_set_title, include: :rate_card_set_versions)
      subject.clone(rate_card_set_version_id, title: rate_card_set_title, include: :rate_card_set_versions)
    end

    context "when #clone is not successful" do
      before do
        allow(subject).to receive(:clone!).with(rate_card_set_version_id, title: rate_card_set_title, include: :rate_card_set_versions).and_raise(Mavenlink::Error, "this didn't work")
      end

      it "returns false" do
        expect(subject.clone(rate_card_set_version_id, title: rate_card_set_title, include: :rate_card_set_versions)).to be_falsey
      end
    end
  end
end
