require "spec_helper"

describe Mavenlink::SubscribedEvent, stub_requests: true, type: :model do
  it_should_behave_like "model", "subscribed_events"
end
