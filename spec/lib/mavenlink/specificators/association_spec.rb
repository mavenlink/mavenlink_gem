require 'spec_helper'

describe Mavenlink::Specificators::Association do
  subject { model.new }

  before { described_class.apply(model) }

  let(:model) do
    Class.new Mavenlink::Model do
      def self.specification
        {'associations' => {'children' => {}, 'parents' => {}}}
      end
    end
  end

  it { should respond_to :children }
  it { should respond_to :parents }

  describe 'real model' do
    subject { Mavenlink::Workspace.new }

    it { should respond_to :primary_counterpart }
    it { should respond_to :participants }
  end
end
