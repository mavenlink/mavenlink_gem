require "spec_helper"

describe Mavenlink::IntegratedResource, stub_requests: true do
  let(:model) { described_class }
  let(:integrated_resource) { model.new(attributes) }
  let(:uri) { "integrated_resources/create_or_update" }
  let(:attributes) {
    {
      "subject_type" => "TimeEntry",
      "subject_id" => 1,
      "service_name" => "Netsuite",
      "service_id" => "1",
      "service_model" => "TimeBill"
    }.merge(attribute_options)
  }
  let(:attribute_options) { {} }
  let(:response) do
    {
      "count" => 1,
      "results" => [{"key" => "integrated_resources", "id" => "7"}],
      "integrated_resources" => {
        "7" => {
          "id" => "7",
          "subject_id" => "1",
          "subject_type" => "TimeEntry",
          "service_id" => "1",
          "service_name" => "Netsuite",
          "service_model" => "TimeBill"
        }
      }
    }
  end

  describe "validations" do
    it { should validate_presence_of :service_id }
    it { should validate_presence_of :service_name }
    it { should validate_presence_of :service_model }
    it { should validate_presence_of :subject_id }
    it { should validate_presence_of :subject_type }
  end

  describe "#save" do
    before do
      allow(integrated_resource.client).to receive(:post).and_call_original
      stub_request :post, "/api/v1/integrated_resources/create_or_update", response
    end

    context "when the model is valid" do
      it "the record is valid" do
        integrated_resource.save
        expect(integrated_resource).to be_a model
        expect(integrated_resource).to be_valid
        expect(integrated_resource).to be_persisted
      end

      it "makes the request with the correct params" do
        integrated_resource.save
        expect(integrated_resource.client).to have_received(:post).with(uri, { integrated_resource: attributes })
      end

      it "returns true" do
        expect(integrated_resource.save).to be_true
      end

      it "loads the response attributes into the integrated resource model" do
        integrated_resource.save
        expect(integrated_resource).to eq(response["integrated_resources"]["7"])
      end
    end

    context "when an invalid attribute is set on the model" do
        let(:attribute_options) { { foo: 666 } }

        it "the record is valid" do
          integrated_resource.save
          expect(integrated_resource).to be_a model
          expect(integrated_resource).to be_valid
          expect(integrated_resource).to be_persisted
        end

        it "ignores invalid attributes when making the request" do
          integrated_resource.save
          expect(integrated_resource.client).to have_received(:post).with(uri, { integrated_resource: attributes.except(:foo)})
        end

        it "returns true" do
          expect(integrated_resource.save).to be_true
        end

        it "loads the response attributes into the integrated resource model" do
          integrated_resource.save
          expect(integrated_resource).to include(response["integrated_resources"]["7"])
        end
      end

    context "when required attributes are missing" do
      let(:attribute_options) { { subject_type: nil } }

      it "the record is not valid" do
        integrated_resource.save
        expect(integrated_resource).to be_a model
        expect(integrated_resource).to_not be_valid
        expect(integrated_resource).to_not be_persisted
      end

      it "does not make the request" do
        integrated_resource.save
        expect(integrated_resource.client).to_not have_received(:post)
      end

      it "returns false" do
        expect(integrated_resource.save).to be_false
      end

      it "logs an error on the modal" do
        integrated_resource.save
        expect(integrated_resource.errors.full_messages).to eq(["Subject type can't be blank"])
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
        expect(integrated_resource).to be_a model
        expect(integrated_resource).to be_valid
        expect(integrated_resource).to_not be_persisted
      end

      it "raise a Mavenlink InvalidRequestError" do
        expect { integrated_resource.save }.to raise_error Mavenlink::InvalidRequestError, /Missing required parameters/
      end
    end
  end
end
