require "spec_helper"

describe Mavenlink::StoryFollow, stub_requests: true, type: :model do
  it_should_behave_like "model", "story_follows"

  describe "associations" do
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :follower }
  end
end
