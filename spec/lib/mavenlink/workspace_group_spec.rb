require 'spec_helper'

describe Mavenlink::WorkspaceGroup, stub_requests: true, type: :model do
  it_should_behave_like 'model', 'workspace_groups'

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
  end

  describe 'associations' do
    it { is_expected.to respond_to :workspaces }
    it { is_expected.to respond_to :external_references }
  end

  describe 'attributes' do
    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :company }
    it { is_expected.to respond_to :add_workspace_ids }
    it { is_expected.to respond_to :remove_workspace_ids }
  end
end
