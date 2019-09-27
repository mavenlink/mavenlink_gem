require "spec_helper"

describe Mavenlink::TimeOffEntry, stub_requests: true do
  it_should_behave_like "model", "time_off_entries"

  describe "association" do
    it { is_expected.to respond_to :user }
  end
end
