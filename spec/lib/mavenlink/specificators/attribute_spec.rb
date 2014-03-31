require 'spec_helper'

describe Mavenlink::Specificators::Attribute do
  subject { model.new }

  before { described_class.apply(model) }

  let(:model) do
    Class.new Mavenlink::Model do
      def self.available_attributes
        %w(one two)
      end
    end
  end

  it { should respond_to :one }
  it { should respond_to :two }

  describe 'real model' do
    subject { Mavenlink::Workspace.new }

    it { should respond_to :title }
    it { should respond_to :description }
  end
end