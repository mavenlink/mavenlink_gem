require 'spec_helper'

describe Mavenlink do
  subject { described_class }

  its(:adapter) { should_not be_nil }
  its(:client) { should_not be_nil }
  its(:default_settings) { should be_a Hash }
  its(:logger) { should be_a Logger }
  its(:specification) { should be_a BrainstemAdaptor::Specification }

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
