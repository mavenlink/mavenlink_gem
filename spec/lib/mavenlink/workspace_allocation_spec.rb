require "spec_helper"

describe Mavenlink::WorkspaceAllocation, stub_requests: true, type: :model do
  it_should_behave_like "model", "workspace_allocations"

  describe "validations" do
    it { is_expected.to validate_presence_of "resource_id" }
    it { is_expected.to validate_presence_of "start_date" }
    it { is_expected.to validate_presence_of "end_date" }
    it { is_expected.to validate_presence_of "minutes" }
  end

  describe "associations" do
    it { is_expected.to respond_to "workspace_resource" }
    it { is_expected.to respond_to "workspace" }
    it { is_expected.to respond_to "creator" }
    it { is_expected.to respond_to "updater" }
    it { is_expected.to respond_to "external_references" }
  end

  describe "#split_allocation" do
    subject { described_class.new(id: "5555", end_date: "2022-06-22") }
    let(:date) { Date.today.to_s }
    let(:response) do
      {
        "count": 2,
        "results": [
          {
            "key": "workspace_allocations",
            "id": "5555"
          },
          {
            "key": "workspace_allocations",
            "id": "1111"
          }
        ],
        "workspace_allocations": {
          "5555": {
            "start_date": "2022-06-07",
            "end_date": "2022-06-14",
            "minutes": 1069,
            "created_at": "2022-04-08T14:21:47-07:00",
            "updated_at": "2022-05-09T13:49:55-07:00",
            "id": "5555"
          },
          "1111": {
            "start_date": "2022-06-15",
            "end_date": "2022-06-22",
            "minutes": 1284,
            "created_at": "2022-05-09T13:49:55-07:00",
            "updated_at": "2022-05-09T13:49:55-07:00",
            "id": "1111"
          }
        }
      }.with_indifferent_access
    end

    before do
      allow(Mavenlink).to receive(:specification).and_return("monkeys" => { "attributes" => ["start_date", "end_date", "minutes", "created_at", "updated_at", "id"] })
    end

    it "puts to the split route with the record id and date" do
      expect(subject.client).to receive(:put).with("workspace_allocations/split", split_date: date, workspace_allocation_id: subject.id) { response }
      expect(Mavenlink::WorkspaceAllocation).to receive(:new).with(response["workspace_allocations"].values.last, nil, subject.client)
      expect { subject.split_allocation(date) }.to change { subject["end_date"] }.from("2022-06-22").to("2022-06-14")
    end
  end
end
