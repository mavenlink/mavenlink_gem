require "spec_helper"

describe Mavenlink::WorkspaceResource, stub_requests: true, type: :model do
  it_should_behave_like "model", "workspace_resources"

  describe "validations" do
    it { is_expected.to validate_presence_of "workspace_id" }
  end

  describe "associations" do
    it { is_expected.to respond_to "participation" }
    it { is_expected.to respond_to "user" }
    it { is_expected.to respond_to "role" }
    it { is_expected.to respond_to "skills" }
    it { is_expected.to respond_to "workspace" }
  end

  describe "#allocations_matching_scheduled_hours" do
    subject { described_class.new(id: "1") }

    before do
      allow(subject.client).to receive(:post)
    end

    it "posts to the allocations_matching_scheduled_hours route" do
      expect(subject.client).to receive(:post).with("#{described_class.collection_name}/allocations_matching_scheduled_hours", id: subject.id)
      subject.allocations_matching_scheduled_hours
    end
  end
end
