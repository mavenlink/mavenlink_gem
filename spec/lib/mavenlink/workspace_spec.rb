require "spec_helper"

describe Mavenlink::Workspace, stub_requests: true, type: :model do
  let(:model) { described_class }

  it { is_expected.to be_a Mavenlink::Model }
  it { is_expected.to be_a Mavenlink::Concerns::Indestructible }

  describe "associations" do
    it { is_expected.to respond_to :next_uncompleted_milestone }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :primary_counterpart }
    it { is_expected.to respond_to :primary_maven }
    it { is_expected.to respond_to :approver }
    it { is_expected.to respond_to :approvers }
    it { is_expected.to respond_to :participants }
    it { is_expected.to respond_to :current_user_participation }
    it { is_expected.to respond_to :participations }
    it { is_expected.to respond_to :timesheet_submissions }
    it { is_expected.to respond_to :workspace_groups }
    it { is_expected.to respond_to :financial_viewers }
    it { is_expected.to respond_to :possible_approvers }
    it { is_expected.to respond_to :workspace_resources }
    it { is_expected.to respond_to :workspace_resources_with_unnamed }
    it { is_expected.to respond_to :status_reports }
    it { is_expected.to respond_to :current_status_report }
    it { is_expected.to respond_to :external_references }
    it { is_expected.to respond_to :account_color }
    it { is_expected.to respond_to :custom_field_values }
  end

  let(:response) do
    {
      "count" => 1,
      "results" => [{ "key" => "workspaces", "id" => "7" }],
      "workspaces" => {
        "7" => { "title" => "My new project", "id" => "7" }
      }
    }
  end

  let(:updated_response) do
    {
      "count" => 1,
      "results" => [{ "key" => "workspaces", "id" => "7" }],
      "workspaces" => {
        "7" => { "title" => "Updated project", "id" => "7" }
      }
    }
  end

  before do
    stub_request :get,    "/api/v1/workspaces?only=7", response
    stub_request :get,    "/api/v1/workspaces?only=8", "count" => 0, "results" => []
    stub_request :post,   "/api/v1/workspaces", response
    stub_request :put,    "/api/v1/workspaces/7", updated_response
    stub_request :delete, "/api/v1/workspaces/4", "count" => 0, "results" => [] # TODO: replace with real one
  end

  describe "association calls" do
    let(:record) { described_class.find(7) }
    let(:response) do
      {
        "count" => 1,
        "results" => [{ "key" => "workspaces", "id" => "7" }, { "key" => "users", "id" => "2" }],
        "users" => {
          "2" => {
            "id" => 2,
            "full_name" => "John Doe"
          }
        },
        "workspaces" => {
          "7" => {
            "title" => "My new project", "id" => "7",
            "participant_ids" => ["2"]
          }
        }
      }
    end

    specify do
      expect(record.participants.count).to eq(1)
    end

    specify do
      expect(record.participants.first).to be_a(Mavenlink::User)
    end

    it "saves the client scope" do
      expect(record.participants.first.client).to eq(record.client)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title).on(:create) }
    it { is_expected.to validate_inclusion_of(:creator_role).in_array(%w[maven buyer]).on(:create) }
  end

  describe "instance methods" do
    subject { model.new(title: "Some title", creator_role: "maven") }

    specify do
      expect(subject.scoped_im).to be_a Mavenlink::Request
    end
  end

  describe "class methods" do
    subject { model }

    describe "#collection_name" do
      subject { super().collection_name }
      it { is_expected.to eq("workspaces") }
    end

    describe ".scoped" do
      subject { model.scoped }

      it { is_expected.to be_a Mavenlink::Request }

      describe "#collection_name" do
        subject { super().collection_name }
        it { is_expected.to eq("workspaces") }
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

    describe ".create" do
      context "valid record" do
        specify do
          expect(model.create(title: "Some title", creator_role: "maven")).to be_a model
        end

        specify do
          expect(model.create(title: "Some title", creator_role: "maven")).to be_valid
        end

        specify do
          expect(model.create(title: "Some title", creator_role: "maven")).to be_persisted
        end
      end

      context "invalid record" do
        specify do
          expect(model.create(title: "", creator_role: "")).to be_a model
        end

        specify do
          expect(model.create(title: "", creator_role: "")).not_to be_valid
        end

        specify do
          expect(model.create(title: "", creator_role: "")).to be_a_new_record
        end
      end
    end

    describe ".create!" do
      context "valid record" do
        specify do
          expect { model.create!(title: "Some title", creator_role: "maven") }.not_to raise_error
        end
      end

      context "invalid record" do
        specify do
          expect { model.create!(title: "", creator_role: "") }.to raise_error Mavenlink::RecordInvalidError, /Title.*blank/
        end
      end
    end

    describe ".models" do
      specify do
        expect(model.models).to be_empty
      end

      specify do
        expect(Mavenlink::Model.models).to include("workspaces" => Mavenlink::Workspace)
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

    describe ".create_attributes" do
      specify do
        expect(model.create_attributes).to be_an Array
      end

      specify do
        expect(model.create_attributes).not_to be_empty
      end
    end

    describe ".update_attributes" do
      specify do
        expect(model.update_attributes).to be_an Array
      end

      specify do
        expect(model.update_attributes).not_to be_empty
      end
    end

    describe ".wrap" do
      specify do
        expect(model.wrap(nil)).to be_a_new_record
      end

      context "existing record" do
        let(:brainstem_record) do
          BrainstemAdaptor::Record.new("workspaces", "7", Mavenlink::Response.new(response))
        end

        specify do
          expect(model.wrap(brainstem_record)).not_to be_a_new_record
        end

        specify do
          expect(model.wrap(brainstem_record)).to be_a Mavenlink::Workspace
        end
      end
    end
  end

  describe "#initialize" do
    it "accepts attributes" do
      expect(model.new(any_custom_key: "value set")).to include(any_custom_key: "value set")
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

  describe "#save" do
    context "valid record" do
      context "new record" do
        subject { model.new(title: "Some title", creator_role: "maven") }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.to change(subject, :persisted?).from(false).to(true)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save }.to change { subject.title }.from("Some title").to("My new project")
        end
      end

      context "persisted record" do
        subject { model.create(title: "Some title", creator_role: "maven") }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save }.to change { subject.title }.from("My new project").to("Updated project")
        end
      end
    end

    context "invalid record" do
      context "new record" do
        subject { model.new(title: "", creator_role: "") }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it "does not perform any requests" do
          expect { subject.save }.not_to change { subject.title }
        end
      end

      context "persisted record" do
        subject { model.create(title: "Some title", creator_role: "maven") }
        before { subject.title = "" }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it "does not change anything" do
          expect { subject.save }.not_to change { subject.title }
        end
      end
    end
  end

  describe "#save!" do
    context "valid record" do
      context "new record" do
        subject { model.new(title: "Some title", creator_role: "maven") }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.to change(subject, :persisted?).from(false).to(true)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save! }.to change { subject.title }.from("Some title").to("My new project")
        end
      end

      context "persisted record" do
        subject { model.create(title: "Some title", creator_role: "maven") }

        it { is_expected.to be_persisted }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.not_to change(subject, :persisted?)
        end

        it "reloads record fields taking it from response" do
          expect { subject.save! }.to change { subject.title }.from("My new project").to("Updated project")
        end
      end
    end

    context "invalid record" do
      context "new record" do
        subject { model.new(title: "", creator_role: "") }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Title.*blank/
        end

        specify do
          expect do
            begin
                     subject.save!
            rescue StandardError
              nil
                   end
          end .not_to change(subject, :persisted?)
        end

        it "does not perform any requests" do
          expect do
            begin
                     subject.save!
            rescue StandardError
              nil
                   end
          end .not_to change { subject.title }
        end
      end

      context "persisted record" do
        subject { model.create(title: "Some title", creator_role: "maven") }
        before { subject.title = "" }

        it { is_expected.to be_persisted }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Title.*blank/
        end

        specify do
          expect do
            begin
                     subject.save!
            rescue StandardError
              nil
                   end
          end .not_to change(subject, :persisted?)
        end

        it "does not change anything" do
          expect do
            begin
                     subject.save!
            rescue StandardError
              nil
                   end
          end .not_to change { subject.title }
        end
      end
    end
  end

  describe "#destroy" do
    specify do
      expect { model.new(id: "4").destroy }.to raise_error Mavenlink::RecordLockedError, /locked.*deleted/
    end
  end

  describe "#association_load_filters" do
    it "return filters to ensure we get hidden workspaces" do
      expect(subject.association_load_filters).to eq(include_archived: true)
    end
  end
end
