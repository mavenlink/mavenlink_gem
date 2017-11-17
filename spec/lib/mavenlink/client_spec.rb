require 'spec_helper'

describe Mavenlink::Client, stub_requests: true do
  it { should respond_to :assignments }
  it { should respond_to :expense_categories }
  it { should respond_to :stories }
  it { should respond_to :story_allocation_days }
  it { should respond_to :users }
  it { should respond_to :workspaces }

  context 'oauth token is not set' do
    specify do
      expect { described_class.new({}) }.to raise_error ArgumentError, /token/
    end
  end

  context 'overriding the enpoint URL' do
    specify do
      endpoint = "http://api.mavenlink.test/api/v1"
      client = described_class.new(oauth_token: '12345', endpoint: endpoint)

      expect(client.send(:endpoint)).to eq endpoint
    end
  end

  describe 'association calls' do
    subject(:client) { described_class.new(oauth_token: '12345') }
    let(:record) { client.workspaces.find(7) }
    let(:response) {
      {
        'count' => 1,
        'results' => [{'key' => 'workspaces', 'id' => '7'}, {'key' => 'users', 'id' => '2'}],
        'users' => {
          '2' => {
            'id' => 2,
            'full_name' => 'John Doe'
          }
        },
        'workspaces' => {
          '7' => {
            'title' => 'My new project', 'id' => '7',
            'participant_ids' => ['2'],
          }
        }
      }
    }

    before do
      stub_request :get, '/api/v1/workspaces?only=7', response
    end

    specify do
      expect(record.participants.count).to eq(1)
    end

    specify do
      expect(record.participants.first).to be_a(Mavenlink::User)
    end

    it 'saves the client scope' do
      expect(record.participants.first.client).to eq(client)
    end
  end

  describe '#assignments' do
    let(:response) { { 'count' => 0, 'results' => [], 'assignments' => {} } }

    before do
      stub_request :get, '/api/v1/assignments', response
    end

    specify do
      expect(subject.assignments).to be_a(Mavenlink::Request)
    end

    specify do
      expect(subject.assignments.collection_name).to eq('assignments')
    end
  end

  describe '#stories' do
    let(:response) { { 'count' => 0, 'results' => [], 'stories' => {} } }

    before do
      stub_request :get, '/api/v1/stories', response
    end

    specify do
      expect(subject.stories).to be_a(Mavenlink::Request)
    end

    specify do
      expect(subject.stories.collection_name).to eq('stories')
    end
  end

  describe '#story_allocation_days' do
    let(:response) { { 'count' => 0, 'results' => [], 'story_allocation_days' => {} } }

    before do
      stub_request :get, '/api/v1/story_allocation_days', response
    end

    specify do
      expect(subject.story_allocation_days).to be_a(Mavenlink::Request)
    end

    specify do
      expect(subject.story_allocation_days.collection_name).to eq('story_allocation_days')
    end
  end

  describe '#users' do
    let(:response) { { 'count' => 0, 'results' => [], 'users' => {} } }

    before do
      stub_request :get, '/api/v1/users', response
    end

    specify do
      expect(subject.users).to be_a(Mavenlink::Request)
    end

    specify do
      expect(subject.users.collection_name).to eq('users')
    end
  end

  describe '#workspaces' do
    let(:response) { { 'count' => 0, 'results' => [], 'workspaces' => {} } }

    before do
      stub_request :get, '/api/v1/workspaces', response
    end

    specify do
      expect(subject.workspaces).to be_a(Mavenlink::Request)
    end

    specify do
      expect(subject.workspaces.collection_name).to eq('workspaces')
    end
  end

  describe 'plain requests' do
    let(:get_path)    { '/get_something' }
    let(:post_path)   { '/post_something' }
    let(:put_path)    { '/put_something' }
    let(:delete_path) { '/delete_something' }
    let(:failing_get_path) { '/fail_to_get_something' }

    let(:get_body)    { {'get'    => true} }
    let(:post_body)   { {'post'   => true} }
    let(:put_body)    { {'put'    => true} }
    let(:delete_body) { {'delete' => true} }
    let(:failing_get_body) { {'get' => "errors"} }

    let(:get_response)    { get_body.merge({'status' => 200}) }
    let(:post_response)   { post_body.merge({'status' => 200}) }
    let(:put_response)    { put_body.merge({'status' => 200}) }
    let(:delete_response) { delete_body.merge({'status' => 200}) }
    let(:failing_get_response) { failing_get_body.merge({'status' => 403}) }

    before do
      stub_request :get,    get_path,    get_body
      stub_request :post,   post_path,   post_body
      stub_request :put,    put_path,    put_body
      stub_request :delete, delete_path, delete_body
      stub_request :get,    failing_get_path, failing_get_body, 403
    end

    describe '#get' do
      specify do
        expect(subject.get(get_path)).to eq(get_response)
      end

      specify do
        expect(subject.get(failing_get_path)).to eq(failing_get_response)
      end
    end

    describe '#post' do
      specify do
        expect(subject.post(post_path)).to eq(post_response)
      end
    end

    describe '#put' do
      specify do
        expect(subject.put(put_path)).to eq(put_response)
      end
    end

    describe '#delete' do
      specify do
        expect(subject.delete(delete_path)).to eq(delete_response)
      end
    end
  end
end
