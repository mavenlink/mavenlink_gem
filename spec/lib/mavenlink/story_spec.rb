require 'spec_helper'

describe Mavenlink::Story, stub_requests: true do
  it_should_behave_like 'model', 'stories'

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :story_type }
    it { should validate_presence_of :workspace_id }
    it { should ensure_inclusion_of(:story_type).in_array(%w(task deliverable milestone)) }
  end

  describe 'associations' do
    it { should respond_to :workspace }
    it { should respond_to :parent }
    it { should respond_to :assignees }
    it { should respond_to :sub_stories }
    it { should respond_to :descendants }
    it { should respond_to :custom_field_values }
  end

  let(:response) {
    {
      'count' => 1,
      'results' => [{'key' => 'stories', 'id' => '7'}],
      'stories' => {
        '7' => {'title' => 'My new record', 'id' => '7'}
      }
    }
  }

  let(:delete_response) {
    {
      'status' => 204
    }
  }

  before do
    stub_request :get,    "/api/v1/stories?only=7", response
    stub_request :get,    "/api/v1/stories?only=8", {'count' => 0, 'results' => []}
    stub_request :post,   "/api/v1/stories", response
    stub_request :delete, "/api/v1/stories/4", {}, 204
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
        subject { described_class.new(title: 'the record', story_type: 'task', workspace_id: '1') }

        specify do
          expect(subject.save).to be_true
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.title }.from('the record').to('My new record')
        end
      end
    end
  end

  describe '#destroy' do
    specify do
      expect(described_class.new(id: '4').destroy).to eq(delete_response)
    end
  end
end
