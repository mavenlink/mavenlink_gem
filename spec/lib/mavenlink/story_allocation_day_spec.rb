require 'spec_helper'

describe Mavenlink::StoryAllocationDay, stub_requests: true do
  it_should_behave_like 'model', 'story_allocation_days'

  describe 'validations' do
    it { should validate_presence_of :assignment_id }
    it { should validate_presence_of :date }
    it { should validate_presence_of :minutes }
  end

  describe 'associations' do
    it { should respond_to :assignment }
    it { should respond_to :story }
    it { should respond_to :workspace }
  end

  let(:response) {
    {
      'count' => 1,
      'results' => [{'key' => 'story_allocation_days', 'id' => '7'}],
      'story_allocation_days' => {
        '7' => {'current' => true, 'id' => '7'}
      }
    }
  }

  before do
    stub_request :get,    "/api/v1/story_allocation_days?only=7", response
    stub_request :get,    "/api/v1/story_allocation_days?only=8", {'count' => 0, 'results' => []}
    stub_request :post,   "/api/v1/story_allocation_days", response
    stub_request :delete, "/api/v1/story_allocation_days/4", {'count' => 0, 'results' => []} # TODO: replace with real one
  end

  describe '#save' do
    context 'new record' do
      subject { described_class.new }

      context 'invalid record' do
        specify do
          expect(subject.save).to be_false
        end
      end

      context 'valid record' do
        subject { described_class.new(assignment_id: '1', date: 'today', minutes: '0', current: false) }

        specify do
          expect(subject.save).to be_true
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.current }.from(false).to(true)
        end
      end
    end
  end

  describe '#destroy' do
    # NOTE(SZ) missing specs
    # ... pending do ...
    specify do
      expect { described_class.new(id: '4').destroy }.not_to raise_error
    end
  end
end