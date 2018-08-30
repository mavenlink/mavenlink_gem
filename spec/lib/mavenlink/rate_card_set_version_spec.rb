require "spec_helper"

describe Mavenlink::RateCardSetVersion, stub_requests: true do
	subject { described_class.new(id: 7) }

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
		let(:client) { double(Mavenlink::Client) }

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
