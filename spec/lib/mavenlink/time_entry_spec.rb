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
    it { should respond_to :role }
    it { should respond_to :active_submission }
    it { should respond_to :invoice }
    it { should respond_to :external_references }
  end

  it 'should respond to expected attributes' do
    should respond_to(:created_at, :updated_at, :date_performed, :story_id,
                      :time_in_minutes, :billable, :notes, :rate_in_cents,
                      :currency, :currency_symbol, :currency_base_unit,
                      :user_can_edit, :workspace_id, :user_id, :approved,
                      :role_id, :location)
  end

  describe '.create_attributes' do
    let(:subject) { described_class.create_attributes }

    it 'includes expected attributes' do
      should match_array(%w(workspace_id date_performed time_in_minutes billable cost_rate_in_cents
                            notes rate_in_cents story_id user_id external_reference location role_id))
    end
  end

  describe '.update_attributes' do
    let(:subject) { described_class.update_attributes }

    it 'includes expected attributes' do
      should match_array(%w(date_performed time_in_minutes billable notes cost_rate_in_cents
                            rate_in_cents story_id user_id external_reference role_id workspace_id))
    end
  end
end
