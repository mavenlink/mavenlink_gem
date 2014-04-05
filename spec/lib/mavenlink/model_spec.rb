require 'spec_helper'

describe Mavenlink::Model, stub_requests: true do
  # see workspace_model_spec.rb

  before do
    Mavenlink.stub(:specification).and_return({ 'monkeys' => {'validations' => {'name' => {'presence' => true}},
                                                              'attributes'        => ['name'],
                                                              'create_attributes' => ['name'],
                                                              'update_attributes' => ['name', 'age']} })
  end

  subject :model do
    class Monkey < Mavenlink::Model
      def self.name
        'Mavenlink::Monkey'
      end
    end
    Monkey
  end

  its(:collection_name) { should == 'monkeys'}

  let(:response) {
    {
      'count' => 1,
      'results' => [{'key' => 'monkeys', 'id' => '7'}],
      'monkeys' => {
        '7' => {'name' => 'Masha', 'id' => '7'}
      }
    }
  }

  let(:updated_response) {
    {
      'count' => 1,
      'results' => [{'key' => 'monkeys', 'id' => '7'}],
      'monkeys' => {
        '7' => {'name' => 'Mashka', 'id' => '7'}
      }
    }
  }

  before do
    stub_request :get,    '/api/v1/monkeys?only=7', response
    stub_request :get,    '/api/v1/monkeys?only=8', {'count' => 0, 'results' => []}
    stub_request :post,   '/api/v1/monkeys', response
    stub_request :put,    '/api/v1/monkeys/7', updated_response
    stub_request :delete, '/api/v1/monkeys/7', {}
  end

  describe '.create' do
    context 'valid record' do
      specify do
        expect(model.create(name: 'Masha')).to be_a model
      end

      specify do
        expect(model.create(name: 'Masha')).to be_valid
      end

      specify do
        expect(model.create(name: 'Masha')).to be_persisted
      end
    end

    context 'invalid record' do
      specify do
        expect(model.create(name: '')).to be_a model
      end

      specify do
        expect(model.create(name: '')).not_to be_valid
      end

      specify do
        expect(model.create(name: '')).to be_a_new_record
      end
    end
  end

  describe '.create!' do
    context 'valid record' do
      specify do
        expect { model.create!(name: 'Masha') }.not_to raise_error
      end
    end

    context 'invalid record' do
      specify do
        expect { model.create!(name: '') }.to raise_error Mavenlink::RecordInvalidError, /Name.*blank/
      end
    end
  end

  describe '.models' do
    specify do
      expect(model.models).to be_empty
    end

    specify do
      expect(Mavenlink::Model.models).to include({'monkeys' => Monkey})
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
      expect(model.attributes).to eq(['name'])
    end
  end

  describe '.available_attributes' do
    specify do
      expect(model.available_attributes).to eq(['name', 'age'])
    end
  end

  describe '.create_attributes' do
    specify do
      expect(model.create_attributes).to eq(['name'])
    end
  end

  describe '.update_attributes' do
    specify do
      expect(model.update_attributes).to eq(['name', 'age'])
    end
  end

  describe '.wrap' do
    specify do
      expect(model.wrap(nil)).to be_a_new_record
    end

    context 'existing record' do
      let(:brainstem_record) do
        BrainstemAdaptor::Record.new('monkeys', '7', Mavenlink::Response.new(response))
      end

      specify do
        expect(model.wrap(brainstem_record)).not_to be_a_new_record
      end

      specify do
        expect(model.wrap(brainstem_record)).to be_a Monkey
      end
    end
  end

  describe '#initialize' do
    it 'accepts attributes' do
      expect(model.new(any_custom_key: 'value set')).to include(any_custom_key: 'value set')
    end
  end

  describe '#persisted?' do
    specify do
      expect(model.new).not_to be_persisted
    end

    specify do
      expect(model.new(id: 1)).to be_persisted
    end
  end

  describe '#new_record?' do
    specify do
      expect(model.new).to be_new_record
    end

    specify do
      expect(model.new(id: 1)).not_to be_new_record
    end
  end

  describe 'attributes' do
    specify do
      expect(model.new).to respond_to :name
    end

    specify do
      expect(model.new).to respond_to :age
    end
  end

  describe '#attributes=' do
    subject { model.new(name: 'old') }

    specify do
      expect { subject.attributes = {name: 'new'} }.to change { subject['name'] }.from('old').to('new')
    end
  end

  describe '#to_param' do
    specify do
      expect(model.new(id: 1).to_param).to eq('1')
    end

    specify do
      expect(model.new(id: nil).to_param).to eq(nil)
    end
  end

  describe '#save' do
    context 'valid record' do
      context 'new record' do
        subject { model.new(name: 'Maria') }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.to change(subject, :persisted?).from(false).to(true)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.name }.from('Maria').to('Masha')
        end
      end

      context 'persisted record' do
        subject { model.create(name: 'Maria') }

        it { should be_persisted }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.name }.from('Masha').to('Mashka')
        end
      end
    end

    context 'invalid record' do
      context 'new record' do
        subject { model.new(name: '') }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it 'does not perform any requests' do
          expect { subject.save }.not_to change { subject.name }
        end
      end

      context 'persisted record' do
        subject { model.create(name: 'Maria') }
        before { subject.name = '' }

        it { should be_persisted }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it 'does not change anything' do
          expect { subject.save }.not_to change { subject.name }
        end
      end
    end
  end

  describe '#save!' do
    context 'valid record' do
      context 'new record' do
        subject { model.new(name: 'Maria') }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.to change(subject, :persisted?).from(false).to(true)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save! }.to change { subject.name }.from('Maria').to('Masha')
        end
      end

      context 'persisted record' do
        subject { model.create(name: 'Maria') }

        it { should be_persisted }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.not_to change(subject, :persisted?)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save! }.to change { subject.name }.from('Masha').to('Mashka')
        end
      end
    end

    context 'invalid record' do
      context 'new record' do
        subject { model.new(name: '') }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Name.*blank/
        end

        specify do
          expect { subject.save! rescue nil }.not_to change(subject, :persisted?)
        end

        it 'does not perform any requests' do
          expect { subject.save! rescue nil }.not_to change { subject.name }
        end
      end

      context 'persisted record' do
        subject { model.create(name: 'Maria') }
        before { subject.name = '' }

        it { should be_persisted }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Name.*blank/
        end

        specify do
          expect { subject.save! rescue nil }.not_to change(subject, :persisted?)
        end

        it 'does not change anything' do
          expect { subject.save! rescue nil }.not_to change { subject.name }
        end
      end
    end
  end

  describe '#update_attributes' do
    context 'valid record' do
      context 'new record' do
        subject { model.new }

        specify do
          expect(subject.update_attributes(name: 'Maria')).to eq(true)
        end

        specify do
          expect { subject.update_attributes(name: 'Maria') }.to change(subject, :persisted?).from(false).to(true)
        end
      end

      context 'persisted record' do
        subject { model.create(name: 'Maria') }

        it { should be_persisted }

        specify do
          expect(subject.update_attributes(name: 'mashka')).to eq(true)
        end

        specify do
          expect { subject.update_attributes(name: 'test') }.not_to change(subject, :persisted?)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.update_attributes(name: 'test') }.to change { subject.name }.from('Masha').to('Mashka')
        end
      end
    end

    # TODO: invalid record, update_attributes!
  end

  describe '#destroy' do
    subject { model.create(name: 'Maria') }

    specify do
      expect { subject.destroy }.not_to raise_error
    end
  end
end