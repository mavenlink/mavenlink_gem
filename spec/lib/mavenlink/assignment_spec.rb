require 'spec_helper'

describe Mavenlink::Assignment, stub_requests: true, type: :model do
  it_should_behave_like 'model', 'assignments'

  it { is_expected.to be_a Mavenlink::Concerns::Indestructible }

  describe 'associations' do
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :assignee }
    it { is_expected.to respond_to :story_allocation_days }
  end

  describe '#destroy' do
    specify { expect { subject.destroy }.to raise_error Mavenlink::RecordLockedError }
  end
end
