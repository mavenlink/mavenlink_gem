require 'spec_helper'

describe Mavenlink::Workspace, stub_requests: true do
  let(:model) { described_class }

  it { should be_a Mavenlink::Model }
  it { should be_a Mavenlink::Concerns::Indestructible }

  let(:response) {
    {
      'count' => 1,
      'results' => [{'key' => 'workspaces', 'id' => '7'}],
      'workspaces' => {
        '7' => {'title' => 'My new project', 'id' => '7'}
      }
    }
  }

  before do
    stub_request :get,    '/api/v1/workspaces?only=7', response
    stub_request :get,    '/api/v1/workspaces?only=8', {'count' => 0, 'results' => []}
    stub_request :post,   '/api/v1/workspaces', response
    stub_request :delete, '/api/v1/workspaces/4', {'count' => 0, 'results' => []} # TODO: replace with real one
  end

  describe 'validations' do
    context 'new record' do
      it { should be_a_new_record }
      it { should validate_presence_of :title }
      it { should ensure_inclusion_of(:creator_role).in_array(%w[maven buyer]) }
      it { should_not allow_value(nil).for(:creator_role) }
    end

    context 'persisted record' do
      subject { described_class.new(id: 12) }
      it { should be_persisted }
      it { should validate_presence_of :title }
      it { should ensure_inclusion_of(:creator_role).in_array(%w[maven buyer]) }
      it { should allow_value(nil).for(:creator_role) }
    end
  end

  describe 'class methods' do
    subject { model }
    its(:collection_name) { should == 'workspaces' }

    describe '.scoped' do
      subject { model.scoped }

      it { should be_a Mavenlink::Request }
      its(:collection_name) { should == 'workspaces' }
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
        expect(Mavenlink::Model.models).to include({'workspaces' => Mavenlink::Workspace})
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

    describe '.create_attributes' do
      specify do
        expect(model.create_attributes).to be_an Array
      end

      specify do
        expect(model.create_attributes).not_to be_empty
      end
    end

    describe '.update_attributes' do
      specify do
        expect(model.update_attributes).to be_an Array
      end

      specify do
        expect(model.update_attributes).not_to be_empty
      end
    end

    describe '.wrap' do
      specify do
        expect(model.wrap(nil)).to be_a_new_record
      end

      context 'existing record' do
        let(:brainstem_record) do
          BrainstemAdaptor::Record.new('workspaces', '7', Mavenlink::Response.new(response))
        end

        specify do
          expect(model.wrap(brainstem_record)).not_to be_a_new_record
        end

        specify do
          expect(model.wrap(brainstem_record)).to be_a Mavenlink::Workspace
        end
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

  describe '#save' do
    context 'new record' do
      subject { model.new }

      context 'invalid record' do
        specify do
          expect(subject.save).to be_false
        end
      end

      context 'valid record' do
        subject { model.new(title: 'New workspace title', creator_role: 'maven') }

        specify do
          expect(subject.save).to be_true
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.title }.from('New workspace title').to('My new project')
        end
      end
    end
  end

  describe '#destroy' do
    # NOTE(SZ) missing specs
    # ... pending do ...
    specify do
      expect { model.new(id: '4').destroy }.to raise_error Mavenlink::RecordLockedError, /locked.*deleted/
    end
  end
end
