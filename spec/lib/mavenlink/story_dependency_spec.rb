require 'spec_helper'

describe Mavenlink::StoryDependency, stub_requests: true do
  it_should_behave_like 'model', 'story_dependencies'

  describe 'associations' do
    it { should respond_to :source }
    it { should respond_to :target }
  end

  describe 'validations' do
    it { should validate_presence_of :source_id }
    it { should validate_presence_of :target_id }
    it { should validate_presence_of(:workspace_id).on(:create) }
  end
end
