require "spec_helper"

describe Mavenlink::SubscribedEvents::Diff::List, stub_requests: true do
  let(:first_subscribed_event) do
    Mavenlink::SubscribedEvent.new(
      subject_changed_at: "2022-01-01T00:00:00Z",
      previous_payload: {},
      current_payload: {},
      subject_type: "Workspace",
      subject_id: 1,
      user_id: 1111,
      event_type: "workspace:created"
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
      event_type: "workspace:custom_field_created"
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
      event_type: "workspace:custom_field_updated"
    )
  end

  describe "#grouped_diffs" do
  end
end
