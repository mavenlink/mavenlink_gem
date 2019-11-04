require "spec_helper"

describe Mavenlink::Specificators::Association do
  subject { model.new }

  before { described_class.apply(model) }

  let(:model) do
    Class.new Mavenlink::Model do
      def self.specification
        { "associations" => { "children" => {}, "parents" => {} } }
      end
    end
  end

  it { is_expected.to respond_to :children }
  it { is_expected.to respond_to :parents }

  describe "real model" do
    subject { Mavenlink::Workspace.new }

    it { is_expected.to respond_to :primary_counterpart }
    it { is_expected.to respond_to :participants }
  end
end
