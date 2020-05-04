require "spec_helper"

describe Mavenlink::Story, stub_requests: true, type: :model do
  it_should_behave_like "model", "stories"

  describe "validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :story_type }
    it { is_expected.to validate_presence_of :workspace_id }
    it { is_expected.to validate_inclusion_of(:story_type).in_array(%w[task deliverable milestone]) }
  end

  describe "associations" do
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :parent }
    it { is_expected.to respond_to :root }
    it { is_expected.to respond_to :assignees }
    it { is_expected.to respond_to :sub_stories }
    it { is_expected.to respond_to :descendants }
    it { is_expected.to respond_to :ancestors }
    it { is_expected.to respond_to :custom_field_values }
    it { is_expected.to respond_to :external_references }
    it { is_expected.to respond_to :current_assignments }
    it { is_expected.to respond_to :workspace_resources }
    it { is_expected.to respond_to :workspace_resources_with_unnamed }
    it { is_expected.to respond_to :potential_workspace_resources }
    it { is_expected.to respond_to :potential_workspace_resources_with_unnamed }
    it { is_expected.to respond_to :replies }
    it { is_expected.to respond_to :story_state_changes }
    it { is_expected.to respond_to :attachments }
    it { is_expected.to respond_to :source_dependencies }
    it { is_expected.to respond_to :target_dependencies }
    it { is_expected.to respond_to :assigned_role }
  end

  let(:response) do
    {
      "count" => 1,
      "results" => [{ "key" => "stories", "id" => "7" }],
      "stories" => {
        "7" => { "title" => "My new record", "id" => "7" }
      }
    }
  end

  before do
    stub_request :get,    "/api/v1/stories?only=7", response
    stub_request :get,    "/api/v1/stories?only=8", "count" => 0, "results" => []
    stub_request :post,   "/api/v1/stories", response
    stub_request :delete, "/api/v1/stories/4", {}
  end

  describe "#save" do
    context "new record" do
      subject { described_class.new }

      context "invalid record" do
        specify do
          expect(subject.save).to be_falsey
        end
      end

      context "valid record" do
        subject { described_class.new(title: "the record", story_type: "task", workspace_id: "1") }

        specify do
          expect(subject.save).to be_truthy
        end

        it "reloads record fields taking it from response" do
          expect { subject.save }.to change { subject.title }.from("the record").to("My new record")
        end
      end
    end
  end

  describe "#destroy" do
    specify do
      expect(described_class.new(id: "4").destroy).to be_blank
    end
  end

  describe "#association_load_filters" do
    it "return filters to ensure we get hidden stories" do
      expect(subject.association_load_filters).to eq(
        all_on_account: true,
        show_archived: true,
        show_deleted: true,
        show_from_archived_workspaces: true
      )
    end
  end
end
