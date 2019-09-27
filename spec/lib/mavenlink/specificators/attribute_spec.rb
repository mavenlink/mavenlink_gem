require "spec_helper"

describe Mavenlink::Specificators::Attribute do
  subject { model.new }

  before { described_class.apply(model) }

  let(:model) do
    Class.new Mavenlink::Model do
      def self.available_attributes
        %w[one two]
      end
    end
  end

  it { is_expected.to respond_to :one }
  it { is_expected.to respond_to :two }

  describe "real model" do
    subject { Mavenlink::Workspace.new }

    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :description }
  end
end
