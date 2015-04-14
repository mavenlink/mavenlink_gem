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
      expect(response.client).to be_a Mavenlink::Client
    end

    it 'returns records in a proper order' do
      expect(response.results[0]).to be_a Mavenlink::Workspace
      expect(response.results[1]).to be_a Mavenlink::User
    end
  end
end
