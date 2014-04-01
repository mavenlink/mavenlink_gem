require 'spec_helper'

describe Mavenlink::TimeEntry, stub_requests: true do
  it_should_behave_like 'model', 'time_entries'

  describe 'validations' do
    it { should validate_presence_of :workspace_id }
    it { should validate_presence_of :date_performed }
    it { should validate_presence_of :time_in_minutes }
  end

  describe 'associations' do
    it { should respond_to :workspace }
    it { should respond_to :user }
    it { should respond_to :story }
  end
end
