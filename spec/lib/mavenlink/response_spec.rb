require 'spec_helper'

describe Mavenlink::Response, stub_requests: true do
  let(:response_data) {
    {
      'count' => 2,
      'results' => [{'key' => 'workspaces', 'id' => '7'}, {'key' => 'users', 'id' => '9'}],
      'workspaces' => {
        '7' => {'title' => 'My new project'},
        '9' => {'title' => 'My second project'},
      },
      'users' => {
        '1' => {'title' => 'My second project'},
        '9' => {'title' => 'My new project'},
      }
    }
  }

  subject(:response) { described_class.new(response_data) }

  describe '#results' do
    specify do
      expect(response.results).to have(2).records
    end

    it 'checks for client' do
      expect(response).to respond_to (:client)
      expect(response.client).to be_a Mavenlink::Client
    end

    it 'returns records in a proper order' do
      expect(response.results[0]).to be_a Mavenlink::Workspace
      expect(response.results[1]).to be_a Mavenlink::User
    end

  end

  describe '#client' do
    specify 'default client' do
      expect(response.client).to be_a Mavenlink::Client
    end

    context 'custom client set' do
      let(:client) { Mavenlink::Client.new(oauth_token: 'new one') }
      subject(:response) { described_class.new(response_data, client) }
      its(:client) { should eq(client) }
    end
  end
end
