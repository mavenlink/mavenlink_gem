require 'spec_helper'

describe Mavenlink::Settings do
  describe '.[]' do
    before do
      described_class[:new_for_test][:config_var] = 'config value'
    end

    it 'stores settings' do
      expect(described_class[:new_for_test][:config_var]).to eq('config value')
    end

    it 'does not override other namespaces' do
      expect(described_class[:another_for_test][:config_var]).to be_nil
    end
  end
end