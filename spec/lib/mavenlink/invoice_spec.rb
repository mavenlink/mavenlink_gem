require 'spec_helper'

describe Mavenlink::Invoice, stub_requests: true do
  subject { described_class.send(:new) }

  describe 'associations' do
    it { should respond_to :workspaces }
    it { should respond_to :user }
    it { should respond_to :recipient }
    it { should respond_to :time_entries }
    it { should respond_to :expenses }
  end

  it { should be_a Mavenlink::Concerns::LockedRecord }
  it { should be_a Mavenlink::Concerns::Indestructible }

  describe '#save' do
    specify { expect { subject.save }.to raise_error Mavenlink::RecordLockedError }
  end

  describe '#destroy' do
    specify { expect { subject.destroy }.to raise_error Mavenlink::RecordLockedError }
  end

  let(:collection_name) { 'invoices' }

  let(:model) { described_class }

  let(:response) {
    {
      'count' => 1,
      'results' => [{'key' => collection_name, 'id' => '7'}],
      collection_name => {
        '7' => {'title' => 'My new record', 'id' => '7'}
      }
    }
  }

  before do
    stub_request :get,    "/api/v1/#{collection_name}?only=7", response
    stub_request :get,    "/api/v1/#{collection_name}?only=8", {'count' => 0, 'results' => []}
    stub_request :post,   "/api/v1/#{collection_name}", response
    stub_request :delete, "/api/v1/#{collection_name}/4", {}
  end

  describe 'class methods' do
    subject { model }
    its(:collection_name) { should == collection_name }

    describe '.scoped' do
      subject { model.scoped }

      it { should be_a Mavenlink::Request }
      its(:collection_name) { should == collection_name }
    end

    describe '.find' do
      specify do
        expect(model.find(7)).to be_a model
      end

      specify do
        expect(model.find(7).id).to eq('7')
      end

      specify do
        expect(model.find(8)).to be_nil
      end
    end

    describe '.models' do
      specify do
        expect(model.models).to be_empty
      end

      specify do
        expect(Mavenlink::Model.models).to include({collection_name => model})
      end
    end

    describe '.specification' do
      specify do
        expect(model.specification).to be_a Hash
      end

      specify do
        expect(model.specification).not_to be_empty
      end
    end

    describe '.attributes' do
      specify do
        expect(model.attributes).to be_an Array
      end

      specify do
        expect(model.attributes).not_to be_empty
      end
    end

    describe '.available_attributes' do
      specify do
        expect(model.available_attributes).to be_an Array
      end

      specify do
        expect(model.available_attributes).not_to be_empty
      end
    end

    describe '.wrap' do
      context 'existing record' do
        let(:brainstem_record) do
          BrainstemAdaptor::Record.new(collection_name, '7', Mavenlink::Response.new(response))
        end

        specify do
          expect(model.wrap(brainstem_record)).not_to be_a_new_record
        end

        specify do
          expect(model.wrap(brainstem_record)).to be_a model
        end
      end
    end
  end

  describe '#initialize' do
    it 'accepts attributes' do
      expect(model.send(:new, any_custom_key: 'value set')).to include(any_custom_key: 'value set')
    end
  end

  describe '#persisted?' do
    specify do
      expect(model.send(:new)).to be_persisted
    end

    specify do
      expect(model.send(:new, id: 1)).to be_persisted
    end
  end

  describe '#new_record?' do
    specify do
      expect(model.send(:new)).not_to be_new_record
    end

    specify do
      expect(model.send(:new, id: 1)).not_to be_new_record
    end
  end
end
