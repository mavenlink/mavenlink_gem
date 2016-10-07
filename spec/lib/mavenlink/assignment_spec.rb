require 'spec_helper'

describe Mavenlink::Assignment, stub_requests: true do
  it_should_behave_like 'model', 'assignments'

  it { should be_a Mavenlink::Concerns::Indestructible }

  describe 'associations' do
    it { should respond_to :story }
    it { should respond_to :assignee }
    it { should respond_to :story_allocation_days }
  end

  describe '#destroy' do
    specify { expect { subject.destroy }.to raise_error Mavenlink::RecordLockedError }
  end
end
