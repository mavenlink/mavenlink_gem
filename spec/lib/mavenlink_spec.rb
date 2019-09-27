require 'spec_helper'

describe Mavenlink do
  subject { described_class }

  describe '#adapter' do
    subject { super().adapter }
    it { is_expected.not_to be_nil }
  end

  describe '#client' do
    subject { super().client }
    it { is_expected.not_to be_nil }
  end

  describe '#default_settings' do
    subject { super().default_settings }
    it { is_expected.to be_a Hash }
  end

  describe '#logger' do
    subject { super().logger }
    it { is_expected.to be_a Logger }
  end

  describe '#specification' do
    subject { super().specification }
    it { is_expected.to be_a BrainstemAdaptor::Specification }
  end

  describe '.adapter=' do
    let(:adapter) { double('adapter') }

    specify do
      expect { Mavenlink.adapter = adapter }.to change(Mavenlink, :adapter).to(adapter)
    end
  end

  describe '.logger=' do
    let(:logger) { double('logger') }

    specify do
      expect { Mavenlink.logger = logger }.to change(Mavenlink, :logger).to(logger)
    end
  end

  describe '.oauth_token=' do
    specify do
      expect { Mavenlink.oauth_token = 'new token' }.to change { Mavenlink::Settings[:default][:oauth_token] }.from('token').to('new token')
    end
  end

  describe '.perform_validations=' do
    before do
      Mavenlink.perform_validations = false
    end

    specify do
      expect { Mavenlink.perform_validations = true }.to change { Mavenlink::Settings[:default][:perform_validations] }.to(true)
    end
  end
end
