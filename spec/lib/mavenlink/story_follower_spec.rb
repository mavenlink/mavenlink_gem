require "spec_helper"

describe Mavenlink::StoryFollower, type: :model do
  describe "associations" do
    it { is_expected.to respond_to :follower }
    it { is_expected.to respond_to :story }
  end
end