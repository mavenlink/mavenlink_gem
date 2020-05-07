require "spec_helper"

describe Mavenlink::Model, stub_requests: true, type: :model do
  # see workspace_model_spec.rb

  before do
    allow(Mavenlink).to receive(:specification).and_return("monkeys" => { "validations" => { "name" => { "presence" => true } },
                                                                          "attributes" => ["name"],
                                                                          "create_attributes" => ["name"],
                                                                          "update_attributes" => %w[name age],
                                                                          "associations" => {
                                                                            "relatives" => {
                                                                              "foreign_key" => "relative_ids",
                                                                              "collection" => "monkeys"
                                                                            }
                                                                          } })
  end

  subject :model do
    class Monkey < Mavenlink::Model
      def self.name
        "Mavenlink::Monkey"
      end

      def association_load_filters
        {
          some: "filter"
        }
      end
    end
    Monkey
  end

  describe "#collection_name" do
    subject { super().collection_name }
    it { is_expected.to eq("monkeys") }
  end

  let(:response) do
    {
      "count" => 1,
      "results" => [{ "key" => "monkeys", "id" => "7" }],
      "monkeys" => {
        "7" => { "name" => "Masha", "id" => "7" }
      }
    }
  end

  let(:updated_response) do
    {
      "count" => 1,
      "results" => [{ "key" => "monkeys", "id" => "7" }],
      "monkeys" => {
        "7" => { "name" => "Mashka", "id" => "7" }
      }
    }
  end

  before do
    stub_request :get,    "/api/v1/monkeys?only=7", response
    stub_request :get,    "/api/v1/monkeys?only=7", response
    stub_request :get,    "/api/v1/monkeys?only=8", "count" => 0, "results" => []
    stub_request :post,   "/api/v1/monkeys", response
    stub_request :put,    "/api/v1/monkeys/7", updated_response
    stub_request :delete, "/api/v1/monkeys/7", {}
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

  describe ".create" do
    context "valid record" do
      specify do
        expect(model.create(name: "Masha")).to be_a model
      end

      specify do
        expect(model.create(name: "Masha")).to be_valid
      end

      specify do
        expect(model.create(name: "Masha")).to be_persisted
      end
    end

    context "invalid record" do
      specify do
        expect(model.create(name: "")).to be_a model
      end

      specify do
        expect(model.create(name: "")).not_to be_valid
      end

      specify do
        expect(model.create(name: "")).to be_a_new_record
      end
    end
  end

  describe ".create!" do
    context "valid record" do
      specify do
        expect { model.create!(name: "Masha") }.not_to raise_error
      end
    end

    context "invalid record" do
      specify do
        expect { model.create!(name: "") }.to raise_error Mavenlink::RecordInvalidError, /Name.*blank/
      end
    end
  end

  describe ".models" do
    specify do
      expect(model.models).to be_empty
    end

    specify do
      expect(Mavenlink::Model.models).to include("monkeys" => Monkey)
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
      expect(model.attributes).to eq(["name"])
    end
  end

  describe ".available_attributes" do
    specify do
      expect(model.available_attributes).to eq(%w[name age])
    end
  end

  describe ".create_attributes" do
    specify do
      expect(model.create_attributes).to eq(["name"])
    end
  end

  describe ".update_attributes" do
    specify do
      expect(model.update_attributes).to eq(%w[name age])
    end
  end

  describe ".wrap" do
    specify do
      expect(model.wrap(nil)).to be_a_new_record
    end

    context "existing record" do
      let(:brainstem_record) do
        BrainstemAdaptor::Record.new("monkeys", "7", Mavenlink::Response.new(response))
      end

      specify do
        expect(model.wrap(brainstem_record)).not_to be_a_new_record
      end

      specify do
        expect(model.wrap(brainstem_record)).to be_a Monkey
      end
    end
  end

  describe "#initialize" do
    it "accepts attributes" do
      expect(model.new(any_custom_key: "value set")).to include(any_custom_key: "value set")
    end

    it "checks for client" do
      expect(model.new).to respond_to :client
      expect(model.new.client).to be_a Mavenlink::Client
    end

    it "sets the associations_specification" do
      expect(model.new.instance_variable_get(:@associations_specification)).to be_present
    end
  end

  describe "#client" do
    specify "default client" do
      expect(model.new.client).to be_a Mavenlink::Client
    end

    context "custom client set" do
      let(:client) { Mavenlink::Client.new(oauth_token: "new one") }
      subject { described_class.new({ test: "set" }, nil, client) }

      describe "#client" do
        subject { super().client }
        it { is_expected.to eq(client) }
      end
    end
  end

  describe "#persisted?" do
    specify do
      expect(model.new).not_to be_persisted
    end

    specify do
      expect(model.new(id: 1)).to be_persisted
    end
  end

  describe "#new_record?" do
    specify do
      expect(model.new).to be_new_record
    end

    specify do
      expect(model.new(id: 1)).not_to be_new_record
    end
  end

  describe "attributes" do
    specify do
      expect(model.new).to respond_to :name
    end

    specify do
      expect(model.new).to respond_to :age
    end
  end

  describe "#attributes=" do
    subject { model.new(name: "old") }

    specify do
      expect { subject.attributes = { name: "new" } }.to change { subject["name"] }.from("old").to("new")
    end
  end

  describe "#to_param" do
    specify do
      expect(model.new(id: 1).to_param).to eq("1")
    end

    specify do
      expect(model.new(id: nil).to_param).to eq(nil)
    end
  end

  describe "#save" do
    context "valid record" do
      context "new record" do
        subject { model.new(name: "Maria") }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.to change(subject, :persisted?).from(false).to(true)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save }.to change { subject.name }.from("Maria").to("Masha")
        end
      end

      context "persisted record" do
        subject { model.create(name: "Maria") }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save }.to change { subject.name }.from("Masha").to("Mashka")
        end
      end
    end

    context "invalid record" do
      context "new record" do
        subject { model.new(name: "") }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it "does not perform any requests" do
          expect { subject.save }.not_to change { subject.name }
        end
      end

      context "persisted record" do
        subject { model.create(name: "Maria") }
        before { subject.name = "" }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it "does not change anything" do
          expect { subject.save }.not_to change { subject.name }
        end
      end
    end
  end

  describe "#save!" do
    context "valid record" do
      context "new record" do
        subject { model.new(name: "Maria") }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.to change(subject, :persisted?).from(false).to(true)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save! }.to change { subject.name }.from("Maria").to("Masha")
        end
      end

      context "persisted record" do
        subject { model.create(name: "Maria") }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.not_to change(subject, :persisted?)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save! }.to change { subject.name }.from("Masha").to("Mashka")
        end
      end
    end

    context "invalid record" do
      context "new record" do
        subject { model.new(name: "") }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Name.*blank/
        end

        specify do
          expect { subject.save! rescue nil }.to_not change { subject.persisted? }
        end

        it "does not perform any requests" do
          expect { subject.save! rescue nil }.to_not change { subject.name }
        end
      end

      context "persisted record" do
        subject { model.create(name: "Maria") }
        before { subject.name = "" }

        it { is_expected.to be_persisted }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Name.*blank/
        end

        specify do
          expect { subject.save! rescue nil }.to_not change { subject.persisted? }
        end

        it "does not change anything" do
          expect { subject.save! rescue nil }.to_not change { subject.name }
        end
      end
    end
  end

  describe "#update_attributes" do
    context "valid record" do
      context "new record" do
        subject { model.new }

        specify do
          expect(subject.update_attributes(name: "Maria")).to eq(true)
        end

        specify do
          expect { subject.update_attributes(name: "Maria") }.to change(subject, :persisted?).from(false).to(true)
        end
      end

      context "persisted record" do
        subject { model.create(name: "Maria") }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.update_attributes(name: "mashka")).to eq(true)
        end

        specify do
          expect { subject.update_attributes(name: "test") }.not_to change(subject, :persisted?)
        end

        it "reloads record fields taking it from response" do
          expect { subject.update_attributes(name: "test") }.to change { subject.name }.from("Masha").to("Mashka")
        end
      end
    end

    # TODO: invalid record, update_attributes!
  end

  describe "#destroy" do
    subject { model.create(name: "Maria") }

    specify do
      expect { subject.destroy }.not_to raise_error
    end
  end

  describe "#reload_association" do
    subject { model.new(id: "7", name: "Maria") }
    let(:filters) do
      {
        include: "relatives",
        some: "filter"
      }.stringify_keys
    end
    let(:faraday_response) { instance_double(Faraday::Response, body: response_with_relatives.to_json) }
    let(:response_with_relatives) do
      original = response
      original["monkeys"]["7"]["relative_ids"] = ["10"]
      original["monkeys"]["10"] = {
        "name" => "John",
        "id" => "10"
      }
      original
    end

    before do
      allow(subject).to receive(:specification) { Mavenlink.specification["monkeys"] }
    end

    it "uses the specified filters" do
      expect_any_instance_of(Faraday::Connection).to receive(:get).with("monkeys/#{subject.id}", hash_including(filters)) { faraday_response }
      expect(subject.relatives.count).to eq(1)
      expect(subject.relatives.first["id"]).to eq("10")
    end
  end
end
