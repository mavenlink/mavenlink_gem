require "spec_helper"

describe Mavenlink::SubscribedEvents::Diff::List, stub_requests: true do
  describe "#initialize" do
    it "raises an ArgumentError when the input is not an array of subscribed events" do
      expect { described_class.new(Mavenlink::SubscribedEvent.new) }.to raise_error(
        ArgumentError,
        described_class::BAD_COLLECTION_MESSAGE
      )

      expect { described_class.new([Mavenlink::SubscribedEvent.new, Mavenlink::Workspace.new]) }.to raise_error(
        ArgumentError,
        described_class::BAD_COLLECTION_MESSAGE
      )
    end

    it "raises an ArgumentError when the input collection do not include required fields" do
      expect { described_class.new([Mavenlink::SubscribedEvent.new]) }.to raise_error(
        ArgumentError,
        described_class::MISSING_FIELDS_MESSAGE
      )
    end
  end

  describe "#grouped_diffs" do
    subject(:list) do
      described_class.new(
        [
          subscribed_event_1,
          subscribed_event_2,
          subscribed_event_3,
          subscribed_event_4,
          subscribed_event_5,
          subscribed_event_6
        ]
      )
    end

    let(:subscribed_event_1) do
      Mavenlink::SubscribedEvent.new(
        subject_changed_at: "2022-01-01T00:00:00Z",
        previous_payload: {},
        current_payload: {},
        subject_type: "Workspace",
        subject_id: 1,
        subject_ref: {},
        user_id: 1111,
        event_type: "workspace:created"
      )
    end

    let(:subscribed_event_2) do
      Mavenlink::SubscribedEvent.new(
        subject_changed_at: "2022-01-02T00:00:00Z",
        previous_payload: {},
        current_payload: { custom_field_id: "8888" },
        subject_type: "Workspace",
        subject_id: 1,
        subject_ref: {},
        user_id: 2222,
        event_type: "workspace:custom_field_value_created"
      )
    end

    let(:subscribed_event_3) do
      Mavenlink::SubscribedEvent.new(
        subject_changed_at: "2022-01-03T00:00:00Z",
        previous_payload: {},
        current_payload: { custom_field_id: "8888" },
        subject_type: "Workspace",
        subject_id: 1,
        subject_ref: {},
        user_id: 3333,
        event_type: "workspace:custom_field_value_updated"
      )
    end

    let(:subscribed_event_4) do
      Mavenlink::SubscribedEvent.new(
        subject_changed_at: "2022-01-04T00:00:00Z",
        previous_payload: {},
        current_payload: { custom_field_id: "9999" },
        subject_type: "Workspace",
        subject_id: 1,
        subject_ref: {},
        user_id: 3333,
        event_type: "workspace:custom_field_value_created"
      )
    end

    let(:subscribed_event_5) do
      Mavenlink::SubscribedEvent.new(
        subject_changed_at: "2022-01-05T00:00:00Z",
        previous_payload: {},
        current_payload: {},
        subject_type: "Workspace",
        subject_id: 2,
        subject_ref: {},
        user_id: 1111,
        event_type: "workspace:updated"
      )
    end

    let(:subscribed_event_6) do
      Mavenlink::SubscribedEvent.new(
        subject_changed_at: "2022-01-06T00:00:00Z",
        previous_payload: {},
        current_payload: { custom_field_id: "9999" },
        subject_type: "Workspace",
        subject_id: 2,
        subject_ref: {},
        user_id: 3333,
        event_type: "workspace:custom_field_value_created"
      )
    end

    it "returns a unique diff per subject and custom field" do
      expect(list.grouped_diffs.map(&:to_h)).to match_array(
        [
          hash_including(
            subject_id: 1,
            subject_type: "Workspace",
            last_event_type: "workspace:created",
            last_user_id: 1111,
            current_payload: {}
          ),
          hash_including(
            subject_id: 1,
            subject_type: "Workspace",
            last_event_type: "workspace:custom_field_value_updated",
            last_user_id: 3333,
            current_payload: { custom_field_id: "8888" }
          ),
          hash_including(
            subject_id: 1,
            subject_type: "Workspace",
            last_event_type: "workspace:custom_field_value_created",
            last_user_id: 3333,
            current_payload: { custom_field_id: "9999" }
          ),
          hash_including(
            subject_id: 2,
            subject_type: "Workspace",
            last_event_type: "workspace:updated",
            last_user_id: 1111,
            current_payload: {}
          ),
          hash_including(
            subject_id: 2,
            subject_type: "Workspace",
            last_event_type: "workspace:custom_field_value_created",
            last_user_id: 3333,
            current_payload: { custom_field_id: "9999" }
          )
        ]
      )
    end
  end
end
