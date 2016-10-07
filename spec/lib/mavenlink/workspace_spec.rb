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

  let(:updated_response) {
    {
      'count' => 1,
      'results' => [{'key' => 'workspaces', 'id' => '7'}],
      'workspaces' => {
        '7' => {'title' => 'Updated project', 'id' => '7'}
      }
    }
  }

  before do
    stub_request :get,    '/api/v1/workspaces?only=7', response
    stub_request :get,    '/api/v1/workspaces?only=8', {'count' => 0, 'results' => []}
    stub_request :post,   '/api/v1/workspaces', response
    stub_request :put,    '/api/v1/workspaces/7', updated_response
    stub_request :delete, '/api/v1/workspaces/4', {'count' => 0, 'results' => []} # TODO: replace with real one
  end

  describe 'association calls' do
    let(:record) { described_class.find(7) }
    let(:response) {
      {
        'count' => 1,
        'results' => [{'key' => 'workspaces', 'id' => '7'}, {'key' => 'users', 'id' => '2'}],
        'users' => {
          '2' => {
            'id' => 2,
            'full_name' => 'John Doe'
          }
        },
        'workspaces' => {
          '7' => {
            'title' => 'My new project', 'id' => '7',
            'participant_ids' => ['2'],
          }
        }
      }
    }

    specify do
      expect(record.participants.count).to eq(1)
    end

    specify do
      expect(record.participants.first).to be_a(Mavenlink::User)
    end

    it 'saves the client scope' do
      expect(record.participants.first.client).to eq(record.client)
    end
  end

  describe 'validations' do
    context 'new record' do
      it { should be_a_new_record }
      it { should validate_presence_of :title }
    end

    context 'persisted record' do
      subject { described_class.new(id: 12) }
      it { should be_persisted }
      it { should validate_presence_of :title }
      it { should_not ensure_inclusion_of(:creator_role).in_array(%w[maven buyer]) }
      it { should allow_value(nil).for(:creator_role) }
    end
  end

  describe 'instance methods' do
    subject { model.new(title: 'Some title', creator_role: 'maven') }

    specify do
      expect(subject.scoped_im).to be_a Mavenlink::Request
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

    describe '.create' do
      context 'valid record' do
        specify do
          expect(model.create(title: 'Some title', creator_role: 'maven')).to be_a model
        end

        specify do
          expect(model.create(title: 'Some title', creator_role: 'maven')).to be_valid
        end

        specify do
          expect(model.create(title: 'Some title', creator_role: 'maven')).to be_persisted
        end
      end

      context 'invalid record' do
        specify do
          expect(model.create(title: '', creator_role: '')).to be_a model
        end

        specify do
          expect(model.create(title: '', creator_role: '')).not_to be_valid
        end

        specify do
          expect(model.create(title: '', creator_role: '')).to be_a_new_record
        end
      end
    end

    describe '.create!' do
      context 'valid record' do
        specify do
          expect { model.create!(title: 'Some title', creator_role: 'maven') }.not_to raise_error
        end
      end

      context 'invalid record' do
        specify do
          expect { model.create!(title: '', creator_role: '') }.to raise_error Mavenlink::RecordInvalidError, /Title.*blank/
        end
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
    context 'valid record' do
      context 'new record' do
        subject { model.new(title: 'Some title', creator_role: 'maven') }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.to change(subject, :persisted?).from(false).to(true)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.title }.from('Some title').to('My new project')
        end
      end

      context 'persisted record' do
        subject { model.create(title: 'Some title', creator_role: 'maven') }

        it { should be_persisted }

        specify do
          expect(subject.save).to eq(true)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save }.to change { subject.title }.from('My new project').to('Updated project')
        end
      end
    end

    context 'invalid record' do
      context 'new record' do
        subject { model.new(title: '', creator_role: '') }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it 'does not perform any requests' do
          expect { subject.save }.not_to change { subject.title }
        end
      end

      context 'persisted record' do
        subject { model.create(title: 'Some title', creator_role: 'maven') }
        before { subject.title = '' }

        it { should be_persisted }

        specify do
          expect(subject.save).to eq(false)
        end

        specify do
          expect { subject.save }.not_to change(subject, :persisted?)
        end

        it 'does not change anything' do
          expect { subject.save }.not_to change { subject.title }
        end
      end
    end
  end

  describe '#save!' do
    context 'valid record' do
      context 'new record' do
        subject { model.new(title: 'Some title', creator_role: 'maven') }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.to change(subject, :persisted?).from(false).to(true)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save! }.to change { subject.title }.from('Some title').to('My new project')
        end
      end

      context 'persisted record' do
        subject { model.create(title: 'Some title', creator_role: 'maven') }

        it { should be_persisted }

        specify do
          expect(subject.save!).to eq(true)
        end

        specify do
          expect { subject.save! }.not_to change(subject, :persisted?)
        end

        it 'reloads record fields taking it from response' do
          expect { subject.save! }.to change { subject.title }.from('My new project').to('Updated project')
        end
      end
    end

    context 'invalid record' do
      context 'new record' do
        subject { model.new(title: '', creator_role: '') }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Title.*blank/
        end

        specify do
          expect { subject.save! rescue nil }.not_to change(subject, :persisted?)
        end

        it 'does not perform any requests' do
          expect { subject.save! rescue nil }.not_to change { subject.title }
        end
      end

      context 'persisted record' do
        subject { model.create(title: 'Some title', creator_role: 'maven') }
        before { subject.title = '' }

        it { should be_persisted }

        specify do
          expect { subject.save! }.to raise_error Mavenlink::RecordInvalidError, /Title.*blank/
        end

        specify do
          expect { subject.save! rescue nil }.not_to change(subject, :persisted?)
        end

        it 'does not change anything' do
          expect { subject.save! rescue nil }.not_to change { subject.title }
        end
      end
    end
  end

  describe '#destroy' do
    specify do
      expect { model.new(id: '4').destroy }.to raise_error Mavenlink::RecordLockedError, /locked.*deleted/
    end
  end
end
