require 'spec_helper'

describe Mavenlink::Specificators::Validation do
  subject { model.new }

  before { described_class.apply(model) }

  let(:model) do
    Class.new Mavenlink::Model do
      attr_accessor :name

      def self.specification
        {'validations' => {'name' => {'presence' => true}}}
      end

      def self.model_name
        ActiveModel::Name.new(self, nil, 'temp')
      end
    end
  end

  it { should validate_presence_of :name }

  describe 'real model' do
    context 'new record' do
      subject { Mavenlink::Workspace.new }

      it { should validate_presence_of :title }
      it { should ensure_inclusion_of(:creator_role).in_array(%w[maven buyer]) }
      it { should_not allow_value(nil).for(:creator_role) }
    end

    context 'persisted record' do
      subject { Mavenlink::Workspace.new(id: 12) }

      it { should validate_presence_of :title }
      it { should_not ensure_inclusion_of(:creator_role).in_array(%w[maven buyer]) }
      it { should allow_value(nil).for(:creator_role) }
    end
  end
end
