require 'spec_helper'

describe Mavenlink::StoryDependency, stub_requests: true, type: :model do
  it_should_behave_like 'model', 'story_dependencies'

  describe 'associations' do
    it { is_expected.to respond_to :source }
    it { is_expected.to respond_to :target }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :source_id }
    it { is_expected.to validate_presence_of :target_id }
    it { is_expected.to validate_presence_of(:workspace_id).on(:create) }
  end
end
