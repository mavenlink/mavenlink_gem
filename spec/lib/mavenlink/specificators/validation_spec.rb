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

  it { is_expected.to validate_presence_of :name }

  describe 'real model' do
    let(:client) { Object.new }

    context 'new record' do
      subject { Mavenlink::Workspace.new({}, nil, client) }

      it { is_expected.to validate_presence_of :title }
    end

    context 'persisted record' do
      subject { Mavenlink::Workspace.new({ id: 12 }, nil, client) }

      it { is_expected.to validate_presence_of :title }
    end
  end
end
