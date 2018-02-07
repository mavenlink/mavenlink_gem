require 'spec_helper'

describe Mavenlink::WorkspaceGroup, stub_requests: true do
  it_should_behave_like 'model', 'workspace_groups'

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should ensure_inclusion_of(:company).in_array([true, false]) }
    it { should_not allow_value('true').for(:company) }
    it { should_not allow_value('false').for(:company) }
    it { should_not allow_value(nil).for(:company) }
  end

  describe 'associations' do
    it { should respond_to :workspaces }
    it { should respond_to :external_references }
  end

  describe 'attributes' do
    it { should respond_to :name }
    it { should respond_to :company }
    it { should respond_to :add_workspace_ids }
    it { should respond_to :remove_workspace_ids }
  end
end
