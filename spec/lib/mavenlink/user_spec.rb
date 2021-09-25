require "spec_helper"

describe Mavenlink::User, stub_requests: true, type: :model do
  subject { described_class.send(:new) }

  let(:collection_name) { "users" }

  let(:model) { described_class }

  let(:response) do
    {
      "count" => 1,
      "results" => [{ "key" => collection_name, "id" => "7" }],
      collection_name => {
        "7" => { "title" => "My new record", "id" => "7" }
      }
    }
  end

  before do
    stub_request :get,    "/api/v1/#{collection_name}?only=7", response
    stub_request :get,    "/api/v1/#{collection_name}?only=8", "count" => 0, "results" => []
    stub_request :post,   "/api/v1/#{collection_name}", response
    stub_request :delete, "/api/v1/#{collection_name}/4", {}
  end

  describe "associations" do
    it { is_expected.to respond_to :external_references }
    it { is_expected.to respond_to :saml_identities }
    it { is_expected.to respond_to :custom_field_values }
  end

  describe "class methods" do
    subject { model }

    describe "#collection_name" do
      subject { super().collection_name }
      it { is_expected.to eq(collection_name) }
    end

    describe ".scoped" do
      subject { model.scoped }

      it { is_expected.to be_a Mavenlink::Request }

      describe "#collection_name" do
        subject { super().collection_name }
        it { is_expected.to eq(collection_name) }
      end
    end

    describe ".find" do
      specify do
        expect(model.find(7)).to be_a model
      end

      specify do
        expect(model.find(7).id).to eq("7")
      end

      specify do
        expect(model.find(8)).to be_nil
      end
    end

    describe ".models" do
      specify do
        expect(model.models).to be_empty
      end

      specify do
        expect(Mavenlink::Model.models).to include(collection_name => model)
      end
    end

    describe ".specification" do
      specify do
        expect(model.specification).to be_a Hash
      end

      specify do
        expect(model.specification).not_to be_empty
      end
    end

    describe ".attributes" do
      specify do
        expect(model.attributes).to be_an Array
      end

      specify do
        expect(model.attributes).not_to be_empty
      end
    end

    describe ".available_attributes" do
      specify do
        expect(model.available_attributes).to be_an Array
      end

      specify do
        expect(model.available_attributes).not_to be_empty
      end
    end

    describe ".wrap" do
      context "existing record" do
        let(:brainstem_record) do
          BrainstemAdaptor::Record.new(collection_name, "7", Mavenlink::Response.new(response))
        end

        specify do
          expect(model.wrap(brainstem_record)).not_to be_a_new_record
        end

        specify do
          expect(model.wrap(brainstem_record)).to be_a model
        end
      end
    end
  end

  describe "#initialize" do
    it "accepts attributes" do
      expect(model.send(:new, any_custom_key: "value set")).to include(any_custom_key: "value set")
    end
  end

  describe "#persisted?" do
    specify do
      expect(model.send(:new)).not_to be_persisted
    end

    specify do
      expect(model.send(:new, id: 1)).to be_persisted
    end
  end

  describe "#new_record?" do
    specify do
      expect(model.send(:new)).to be_new_record
    end

    specify do
      expect(model.send(:new, id: 1)).not_to be_new_record
    end
  end

  describe "#association_load_filters" do
    let(:response) do
      {
        count: 1,
        results: [
          {
            key: collection_name,
            id: "2"
          }
        ],
        collection_name => {
          "2" => {
            id: "2",
            account_id: other_account_id
          }
        }
      }.deep_stringify_keys
    end

    before do
      subject.id = "1"
      subject.account_id = "12345"
      subject.client.instance_variable_set(:@me, nil)
      stub_request :get, "/api/v1/#{collection_name}/me", response
    end

    context "when the client account id == the subject account id" do
      let(:other_account_id) { "12345" }

      it "includes on_my_account true" do
        expect(subject.association_load_filters).to eq(
          show_disabled: true,
          on_my_account: true
        )
      end
    end

    context "when the client account id != the subject account id" do
      let(:other_account_id) { "54321" }

      it "does not include on_my_account true" do
        expect(subject.association_load_filters).to eq(show_disabled: true)
      end
    end
  end
end
