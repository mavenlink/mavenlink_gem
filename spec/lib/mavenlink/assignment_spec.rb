require 'spec_helper'

describe Mavenlink::Assignment, stub_requests: true do
  describe 'validations' do
    it { should validate_presence_of :story_id }
    it { should validate_presence_of :assignee_id }
  end

  describe 'associations' do
    it { should respond_to :story }
    it { should respond_to :assignee }
    it { should respond_to :story_allocation_days }
  end

  it_should_behave_like 'model', 'assignments'
end