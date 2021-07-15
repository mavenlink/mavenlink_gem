require "spec_helper"

describe Mavenlink::StoryFollower, stub_requests: true, type: :model do
  it_should_behave_like "model", "story_followers"

  describe "associations" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :story }
  end
end