require 'spec_helper'

describe Mavenlink::Client, stub_requests: true do
  it { should respond_to :assignments }
  it { should respond_to :stories }
  it { should respond_to :story_allocation_days }
  it { should respond_to :users }
  it { should respond_to :workspaces }

  context 'oauth token is not set' do
    specify do
      expect { described_class.new({}) }.to raise_error ArgumentError, /token/
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

    let(:get_response)    { {'get'    => true} }
    let(:post_response)   { {'post'   => true} }
    let(:put_response)    { {'put'    => true} }
    let(:delete_response) { {'delete' => true} }

    before do
      stub_request :get,    get_path,    get_response
      stub_request :post,   post_path,   post_response
      stub_request :put,    put_path,    put_response
      stub_request :delete, delete_path, delete_response
      stub_request :get, '/api/v1/expense_categories', ['Travel', 'Mileage', 'Lodging', 'Food', 'Entertainment', 'Other']
    end

    describe '#get' do
      specify do
        expect(subject.get(get_path)).to eq(get_response)
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

    describe '#expense_categories' do
      specify do
        expect(subject.expense_categories).to eq(['Travel', 'Mileage', 'Lodging', 'Food', 'Entertainment', 'Other'])
      end
    end
  end

=begin
  it 'performs requests' do

    #Mavenlink.oauth_token = token
    resp_data = subject.put('workspaces/4894095.json', {workspace: {title: 'I just changed the title'}})

    resp = Mavenlink::Response.new(resp_data)
    resp.to_hash.to_yaml.split('\n').each do |line|
      puts line
    end

    #puts '----------'

    #ap resp.results.first['primary_counterpart']

    #client = Mavenlink::Client.new
    #ap client.workspaces.to_a
    #resp = client.workspaces.create(title: 'Created VIA API', creator_role: 'maven')
    #ap resp.inspect

    #ap client.workspaces.only(4894095).delete
    #ap client.assignments.all
    #ap client.assignments.only('25911375').delete
  end
=end
end