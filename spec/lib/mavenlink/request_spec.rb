require 'spec_helper'

describe Mavenlink::Request, stub_requests: true do
  let(:collection_name) { 'workspaces' }
  let(:client) { Mavenlink.client }

  subject(:request) { described_class.new(collection_name, client) }

  let(:response) {
    {
      'count' => 2,
      'results' => [{'key' => 'workspaces', 'id' => '7'}, {'key' => 'workspaces', 'id' => '9'}],
      'workspaces' => {
        '7' => {'title' => 'My new project'},
        '9' => {'title' => 'My second project'},
      }
    }
  }

  let(:one_record_response) {
    {
      'count' => 1,
      'results' => [{'key' => 'workspaces', 'id' => '7'}],
      'workspaces' => {
        '7' => {'title' => 'My new project'}
      }
    }
  }

  let(:first_page) {
    {
      'count' => 3,
      'results' => [{'key' => 'workspaces', 'id' => '7'}, {'key' => 'workspaces', 'id' => '9'}],
      'workspaces' => {
        '7' => {'title' => 'My new project!'},
        '9' => {'title' => 'My second project!'},
      }
    }
  }

  let(:second_page) {
    {
      'count' => 3,
      'results' => [{'key' => 'workspaces', 'id' => '10'}],
      'workspaces' => {
        '10' => {'title' => 'My last project!'}
      }
    }
  }

  let(:third_invalid_page) {
    {
      'count' => 3,
      'results' => [{'key' => 'workspaces', 'id' => '11'}],
      'workspaces' => {
        '11' => {'title' => 'Not existed project'}
      }
    }
  }

  before do
    stub_request :get, '/api/v1/workspaces?page=1', first_page
    stub_request :get, '/api/v1/workspaces?page=2', second_page
    stub_request :get, '/api/v1/workspaces?page=3', third_invalid_page
    stub_request :get,    '/api/v1/workspaces?only=7', one_record_response
    stub_request :get,    '/api/v1/workspaces?only=8', { 'count' => 0, 'results' => [] }
    stub_request :put,    '/api/v1/workspaces/7',      one_record_response
    stub_request :delete, '/api/v1/workspaces/7',      one_record_response # NOTE(SZ): is this really true?
    stub_request :get,    '/api/v1/workspaces',        response
    stub_request :post,   '/api/v1/workspaces',        one_record_response
  end

  describe '#initialize' do
    let(:client) { double('client') }

    its(:collection_name) { should == 'workspaces' }
    its(:client) { should == client }
    its(:scope) { should == {} }

    context 'no client specified' do
      subject { described_class.new(collection_name) }
      its(:client) { should == Mavenlink.client }
    end
  end

  describe '#chain' do
    specify do
      expect(request.chain({})).to be_a described_class
    end

    specify do
      expect(request.chain({})).not_to eq(request)
    end

    it 'does not change source scope' do
      expect { request.chain({changed: true}) }.not_to change { request.scope }
    end

    it 'merges passed scope' do
      expect(request.chain(changed: true).scope).to have_key(:changed)
      expect(request.chain(changed: true).scope).to have_key('changed')
    end

    it 'assigns the same collection name' do
      expect(request.chain({}).collection_name).to eq(request.collection_name)
    end

    it 'assigns the same client' do
      expect(request.chain({}).client).to eq(request.client)
    end
  end

  describe '#only' do
    context 'empty input' do
      it 'resets the scope' do
        expect(request.only(1).only([]).scope).not_to have_key(:only)
      end
    end
  end

  describe '#without' do
    it 'removes condition from the scope' do
      expect(subject.only(1).without(:only).scope).not_to have_key(:only)
    end
  end

  describe '#find' do
    context 'existed record' do
      it 'returns record wrapped in a model' do
        expect(request.find(7)).to be_a Mavenlink::Workspace
      end
    end

    context 'record does not exist' do
      specify do
        expect(request.find(8)).to be_nil
      end
    end
  end

  describe '#search' do
    specify do
      expect(request.search('text').scope).to include(search: 'text')
    end
  end

  describe '#filter' do
    specify do
      expect(request.filter(recent: true).scope).to include(recent: true)
    end
  end

  describe '#include' do
    specify do
      expect(request.include(:users).scope).to include(include: 'users')
    end

    specify do
      expect(request.include('users').scope).to include(include: 'users')
    end

    specify do
      expect(request.include(%w(users clients)).scope).to include(include: 'users,clients')
    end

    specify do
      expect(request.include('users', 'clients').scope).to include(include: 'users,clients')
    end
  end

  describe '#page' do
    specify do
      expect(request.page(5).scope).to include(page: 5)
    end
  end

  describe '#per_page' do
    specify do
      expect(request.per_page(5).scope).to include(per_page: 5)
    end
  end

  describe '#limit' do
    specify do
      expect(request.limit(5).scope).to include(limit: 5)
    end
  end

  describe '#offset' do
    specify do
      expect(request.offset(5).scope).to include(offset: 5)
    end
  end

  describe 'order' do
    specify do
      expect(request.order(:id, :desc).scope).to include(order: 'id:desc')
    end

    specify do
      expect(request.order(:id, 'desc').scope).to include(order: 'id:desc')
    end

    specify do
      expect(request.order(:id, 'DESC').scope).to include(order: 'id:desc')
    end

    specify do
      expect(request.order(:id, true).scope).to include(order: 'id:desc')
    end

    specify do
      expect(request.order(:id, false).scope).to include(order: 'id')
    end

    specify do
      expect(request.order(:id, 'asc').scope).to include(order: 'id')
    end

    specify do
      expect(request.order(:id, 'ASC').scope).to include(order: 'id')
    end

    specify do
      expect(request.order(:id, :asc).scope).to include(order: 'id')
    end
  end

  describe '#create' do
    specify do
      expect(request.create({})).to be_a Mavenlink::Response
    end

    specify do
      expect(request.create({})).to eq(one_record_response)
    end
  end

  describe '#update' do
    specify do
      expect(request.only(7).update(title: 'New title')).to be_a Mavenlink::Response
    end

    specify do
      expect(request.only(7).update(title: 'New title')).to eq(one_record_response)
    end

    context 'no id specified' do
      specify do
        # NOTE(SZ): should we raise InvalidRequestError instead?
        expect { request.update(title: 'New one') }.to raise_error ArgumentError, /route.*ID/
      end
    end
  end

  describe '#delete' do
    specify do
      expect(request.only(7).delete).to be_a Mavenlink::Response # NOTE(SZ) really?
    end

    specify do
      expect(request.only(7).delete).to eq(one_record_response)
    end

    context 'no id specified' do
      specify do
        # NOTE(SZ): should we raise InvalidRequestError instead?
        expect { request.delete }.to raise_error ArgumentError, /route.*ID/
      end
    end
  end

  describe '#perform' do
    specify do
      expect(request.perform).to be_a Mavenlink::Response
    end

    specify do
      expect(request.perform).to eq(response)
    end

    specify do
      expect(request.perform { one_record_response }).to be_a Mavenlink::Response
    end

    specify do
      expect(request.perform { one_record_response }).to eq(one_record_response)
    end
  end

  describe '#results' do
    specify do
      expect(request.results).to have(2).workspaces
    end

    # NOTE(SZ): missing specs
  end

  describe '#reload' do
    specify do
      expect(request.reload).to have(2).workspaces
    end

    # NOTE(SZ): missing specs
  end

  describe '#scoped' do
    specify do
      expect(request.scoped).to eq(request)
    end
  end

  describe '#to_hash' do
    specify do
      expect(request.to_hash).to eq(request.scope)
    end
  end

  describe '#inspect' do
    specify do
      expect(request.inspect).to eq('#<Mavenlink::Request [<Mavenlink::Workspace:>, <Mavenlink::Workspace:>]>')
    end
  end

  describe '#each_page' do
    specify do
      expect(subject.each_page.to_a).to eq [[{"title"=>"My new project!"}, {"title"=>"My second project!"}],
                                            [{"title"=>"My last project!"}]]
    end

    specify do
      subject.each_page.to_a.flatten.tap do |records|
        expect(records[0]).to be_a Mavenlink::Model
        expect(records[1]).to be_a Mavenlink::Model
        expect(records[2]).to be_a Mavenlink::Model
      end
    end
  end
end