require "spec_helper"

describe Mavenlink::Post, stub_requests: true, type: :model do
  it_should_behave_like "model", "posts"

  describe "validations" do
    it { is_expected.to validate_presence_of :message }
    it { is_expected.to validate_presence_of :workspace_id }
  end

  describe "associations" do
    it { is_expected.to respond_to :subject }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :replies }
    it { is_expected.to respond_to :newest_reply }
    it { is_expected.to respond_to :newest_reply_user }
    it { is_expected.to respond_to :recipients }
    it { is_expected.to respond_to :google_documents }
    it { is_expected.to respond_to :attachments }
  end

  describe "#association_load_filters" do
    it "return filters to ensure we get hidden workspaces" do
      expect(subject.association_load_filters).to eq(from_archived_workspaces: true)
    end
  end
end
