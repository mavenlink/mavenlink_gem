require "spec_helper"

describe Mavenlink::ExternalReference, stub_requests: true do
  let(:model) { described_class }
  let(:external_reference) { model.new(attributes) }
  let(:uri) { "external_references/create_or_update" }
  let(:attributes) {
    {
      "subject_type" => "TimeEntry",
      "subject_id" => 1,
      "service_name" => "Netsuite",
      "service_model_ref" => "1",
      "service_model" => "TimeBill"
    }.merge(attribute_options)
  }
  let(:attribute_options) { {} }
  let(:response) do
    {
      "count" => 1,
      "results" => [{"key" => "external_references", "id" => "7"}],
      "external_references" => {
        "7" => {
          "id" => "7",
          "subject_id" => "1",
          "subject_type" => "TimeEntry",
          "service_model_ref" => "1",
          "service_name" => "Netsuite",
          "service_model" => "TimeBill"
        }
      }
    }
  end

  describe "validations" do
    it { should validate_presence_of :service_model_ref }
    it { should validate_presence_of :service_name }
    it { should validate_presence_of :service_model }
    it { should validate_presence_of :subject_id }
    it { should validate_presence_of :subject_type }
  end

  describe "#save" do
    before do
      allow(external_reference.client).to receive(:post).and_call_original
      stub_request :post, "/api/v1/external_references/create_or_update", response
    end

    context "when the model is valid" do
      it "the record is valid" do
        external_reference.save
        expect(external_reference).to be_a model
        expect(external_reference).to be_valid
        expect(external_reference).to be_persisted
      end

      it "makes the request with the correct params" do
        external_reference.save
        expect(external_reference.client).to have_received(:post).with(uri, { external_reference: attributes })
      end

      it "returns true" do
        expect(external_reference.save).to be_true
      end

      it "loads the response attributes into the integrated resource model" do
        external_reference.save
        expect(external_reference).to eq(response["external_references"]["7"])
      end
    end

    context "when an invalid attribute is set on the model" do
        let(:attribute_options) { { foo: 666 } }

        it "the record is valid" do
          external_reference.save
          expect(external_reference).to be_a model
          expect(external_reference).to be_valid
          expect(external_reference).to be_persisted
        end

        it "ignores invalid attributes when making the request" do
          external_reference.save
          expect(external_reference.client).to have_received(:post).with(uri, { external_reference: attributes.except(:foo)})
        end

        it "returns true" do
          expect(external_reference.save).to be_true
        end

        it "loads the response attributes into the integrated resource model" do
          external_reference.save
          expect(external_reference).to include(response["external_references"]["7"])
        end
      end

    context "when required attributes are missing" do
      let(:attribute_options) { { subject_type: nil } }

      it "the record is not valid" do
        external_reference.save
        expect(external_reference).to be_a model
        expect(external_reference).to_not be_valid
        expect(external_reference).to_not be_persisted
      end

      it "does not make the request" do
        external_reference.save
        expect(external_reference.client).to_not have_received(:post)
      end

      it "returns false" do
        expect(external_reference.save).to be_false
      end

      it "logs an error on the modal" do
        external_reference.save
        expect(external_reference.errors.full_messages).to eq(["Subject type can't be blank"])
      end
    end

    context "when the server responds with error" do
      let(:response) do
        {
          "errors" => [
            {
              "type" => "syntax",
              "message" => "Missing required parameters. Please see our documentation at http://developer.mavenlink.com"
            }
          ]
        }
      end

      after do
        expect(external_reference).to be_a model
        expect(external_reference).to be_valid
        expect(external_reference).to_not be_persisted
      end

      it "raise a Mavenlink InvalidRequestError" do
        expect { external_reference.save }.to raise_error Mavenlink::InvalidRequestError, /Missing required parameters/
      end
    end
  end
end
