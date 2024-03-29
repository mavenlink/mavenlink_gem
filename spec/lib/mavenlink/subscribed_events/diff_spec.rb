require "spec_helper"

describe Mavenlink::SubscribedEvents::Diff, stub_requests: true do
  let(:first_subscribed_event) do
    Mavenlink::SubscribedEvent.new(
      subject_changed_at: "2022-01-01T00:00:00Z",
      previous_payload: {},
      current_payload: {},
      subject_type: "Workspace",
      subject_id: 1,
      user_id: 1111,
      event_type: "workspace:created",
      subject_ref: { id: "1", key: "workspaces" }
    )
  end

  let(:next_subscribed_event) do
    Mavenlink::SubscribedEvent.new(
      subject_changed_at: "2022-01-02T00:00:00Z",
      previous_payload: {},
      current_payload: {},
      subject_type: "Workspace",
      subject_id: 1,
      user_id: 2222,
      event_type: "workspace:updated",
      subject_ref: { id: "1", key: "workspaces" }
    )
  end

  let(:last_subscribed_event) do
    Mavenlink::SubscribedEvent.new(
      subject_changed_at: "2022-01-03T00:00:00Z",
      previous_payload: {},
      current_payload: {},
      subject_type: "Workspace",
      subject_id: 1,
      user_id: 3333,
      event_type: "workspace:deleted",
      subject_ref: { id: "1", key: "workspaces" }
    )
  end

  describe ".from_collection" do
    let(:collection) { [last_subscribed_event, first_subscribed_event, next_subscribed_event] }

    it "initializes a diff from the earliest and latest subscribed events" do
      expect(described_class.from_collection(collection).to_h).to include(
        subject_first_changed_at: "2022-01-01T00:00:00Z",
        subject_last_changed_at: "2022-01-03T00:00:00Z"
      )
    end

    it "raises an ArgumentError if the given array contains non-subscribed events" do
      expect { described_class.from_collection([first_subscribed_event, OpenStruct.new(leclerc: "WDC")]) }.to raise_error(
        ArgumentError,
        described_class::BAD_COLLECTION_MESSAGE
      )
    end
  end

  describe "#initialize" do
    context "when subjects do not match" do
      before do
        first_subscribed_event.subject_id = 9999

        expect(last_subscribed_event.subject_id).to_not eq(first_subscribed_event.subject_id)
      end

      it "raises an ArgumentError" do
        expect { described_class.new(first_subscribed_event, last_subscribed_event) }.to raise_error(
          ArgumentError,
          described_class::SUBJECT_MISMATCH_MESSAGE
        )
      end
    end

    context "when missing required fields" do
      let(:missing_fields_event) do
        Mavenlink::SubscribedEvent.new(
          subject_changed_at: "2022-01-03T00:00:00Z",
          subject_type: "Workpsace",
          subject_id: 1
        )
      end

      it "raises an ArgumentError" do
        expect { described_class.new(first_subscribed_event, missing_fields_event) }.to raise_error(
          ArgumentError,
          described_class::MISSING_FIELDS_MESSAGE
        )
      end
    end
  end

  describe "#to_h" do
    subject(:diff) { described_class.new(first_subscribed_event, last_subscribed_event) }
    let(:subject_attributes) { { id: "1", title: "A workspace" } }
    let(:response) { instance_double(Mavenlink::Response, response_data: { "workspaces" => { "1" => subject_attributes } }) }

    before do
      first_subscribed_event.previous_payload = { not_changed: "value", changed: "value" }
      last_subscribed_event.current_payload = { not_changed: "value", changed: "updated" }

      allow(first_subscribed_event).to receive(:response) { response }
    end

    it "returns diff details between the two events" do
      expect(diff.to_h).to eq(
        {
          subject_type: "Workspace",
          subject_id: 1,
          subject_first_changed_at: "2022-01-01T00:00:00Z",
          subject_last_changed_at: "2022-01-03T00:00:00Z",
          last_user_id: 3333,
          last_event_type: "workspace:deleted",
          payload_changes: {
            changed: {
              from: "value",
              to: "updated"
            }
          },
          previous_payload: {
            not_changed: "value",
            changed: "value"
          },
          current_payload: {
            not_changed: "value",
            changed: "updated"
          },
          subject: subject_attributes
        }.with_indifferent_access
      )
    end
  end
end
