require 'spec_helper'

describe Mavenlink::Post, stub_requests: true do
  it_should_behave_like 'model', 'posts'

  describe 'validations' do
    it { should validate_presence_of :message }
    it { should validate_presence_of :workspace_id }
  end

  describe 'associations' do
    it { should respond_to :subject }
    it { should respond_to :user }
    it { should respond_to :workspace }
    it { should respond_to :story }
    it { should respond_to :replies }
    it { should respond_to :newest_reply }
    it { should respond_to :newest_reply_user }
    it { should respond_to :recipients }
    it { should respond_to :google_documents }
    it { should respond_to :attachments }
  end
end
