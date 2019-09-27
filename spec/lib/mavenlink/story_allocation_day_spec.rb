require "spec_helper"

describe Mavenlink::StoryAllocationDay, stub_requests: true, type: :model do
  it_should_behave_like "model", "story_allocation_days"

  describe "validations" do
    it { is_expected.to validate_presence_of :assignment_id }
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :minutes }
  end

  describe "associations" do
    it { is_expected.to respond_to :assignment }
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :workspace }
  end

  let(:response) do
    {
      "count" => 1,
      "results" => [{ "key" => "story_allocation_days", "id" => "7" }],
      "story_allocation_days" => {
        "7" => { "current" => true, "id" => "7" }
      }
    }
  end

  before do
    stub_request :get,    "/api/v1/story_allocation_days?only=7", response
    stub_request :get,    "/api/v1/story_allocation_days?only=8", "count" => 0, "results" => []
    stub_request :post,   "/api/v1/story_allocation_days", response
    stub_request :delete, "/api/v1/story_allocation_days/4", {}
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
        subject { described_class.new(assignment_id: "1", date: "today", minutes: "0", current: false) }

        specify do
          expect(subject.save).to be_truthy
        end

        it "reloads record fields taking it from response" do
          expect { subject.save }.to change { subject.current }.from(false).to(true)
        end
      end
    end
  end

  describe "#destroy" do
    specify do
      expect(described_class.new(id: "4").destroy).to be_blank
    end
  end
end
