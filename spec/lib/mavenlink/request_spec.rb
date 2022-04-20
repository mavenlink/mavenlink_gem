require "spec_helper"

describe Mavenlink::Request, stub_requests: true do
  let(:collection_name) { "workspaces" }
  let(:client) { Mavenlink.client }

  subject { described_class.new(collection_name, collection_name, client) }

  let(:response) do
    {
      "count" => 2,
      "results" => [{ "key" => "workspaces", "id" => "7" }, { "key" => "workspaces", "id" => "9" }],
      "workspaces" => {
        "7" => { "title" => "My new project" },
        "9" => { "title" => "My second project" }
      }
    }
  end

  let(:one_record_response) do
    {
      "count" => 1,
      "results" => [{ "key" => "workspaces", "id" => "7" }],
      "workspaces" => {
        "7" => { "title" => "My new project" }
      }
    }
  end

  let(:first_page) do
    {
      "count" => 3,
      "results" => [{ "key" => "workspaces", "id" => "7" }, { "key" => "workspaces", "id" => "9" }],
      "workspaces" => {
        "7" => { "title" => "My new project!" },
        "9" => { "title" => "My second project!" }
      }
    }
  end

  let(:second_page) do
    {
      "count" => 3,
      "results" => [{ "key" => "workspaces", "id" => "10" }],
      "workspaces" => {
        "10" => { "title" => "My last project!" }
      }
    }
  end

  let(:third_invalid_page) do
    {
      "count" => 3,
      "results" => [{ "key" => "workspaces", "id" => "11" }],
      "workspaces" => {
        "11" => { "title" => "Not existed project" }
      }
    }
  end

  before do
    stub_request :get,    "/api/v1/workspaces?page=1", first_page
    stub_request :get,    "/api/v1/workspaces?page=2", second_page
    stub_request :get,    "/api/v1/workspaces?page=3", third_invalid_page
    stub_request :get,    "/api/v1/workspaces?only=7", one_record_response
    stub_request :get,    "/api/v1/workspaces?only=8", "count" => 0, "results" => []
    stub_request :put,    "/api/v1/workspaces/7",      one_record_response
    stub_request :delete, "/api/v1/workspaces/7",      {}
    stub_request :get,    "/api/v1/workspaces",        response
    stub_request :post,   "/api/v1/workspaces",        one_record_response
  end

  describe "#initialize" do
    let(:client) { double("client") }

    describe "#collection_name" do
      subject { super().collection_name }
      it { is_expected.to eq("workspaces") }
    end

    describe "#collection_path" do
      subject { super().collection_path }
      it { is_expected.to eq("workspaces") }
    end

    describe "#client" do
      subject { super().client }
      it { is_expected.to eq(client) }
    end

    describe "#scope" do
      subject { super().scope }
      it { is_expected.to eq({}) }
    end

    context "no client specified" do
      subject { described_class.new(collection_name, collection_name) }

      describe "#client" do
        subject { super().client }
        it { is_expected.to eq(Mavenlink.client) }
      end
    end
  end

  describe "#current_page" do
    specify do
      expect(subject.current_page).to eq(1)
    end

    specify do
      expect(subject.page(2).current_page).to eq(2)
    end
  end

  describe "#chain" do
    specify do
      expect(subject.chain({})).to be_a described_class
    end

    specify do
      expect(subject.chain({})).not_to eq(subject)
    end

    it "does not change source scope" do
      expect { subject.chain(changed: true) }.not_to change { subject.scope }
    end

    it "merges passed scope" do
      expect(subject.chain(changed: true).scope).to have_key(:changed)
      expect(subject.chain(changed: true).scope).to have_key("changed")
    end

    it "assigns the same collection name" do
      expect(subject.chain({}).collection_name).to eq(subject.collection_name)
    end

    it "assigns the same client" do
      expect(subject.chain({}).client).to eq(subject.client)
    end
  end

  describe "#only" do
    context "empty input" do
      it "resets the scope" do
        expect(subject.only(1).only([]).scope).not_to have_key(:only)
      end
    end
  end

  describe "#without" do
    it "removes condition from the scope" do
      expect(subject.only(1).without(:only).scope).not_to have_key(:only)
    end
  end

  describe "#find" do
    context "existed record" do
      it "returns record wrapped in a model" do
        expect(subject.find(7)).to be_a Mavenlink::Workspace
      end
    end

    context "record does not exist" do
      specify do
        expect(subject.find(8)).to be_nil
      end
    end
  end

  describe "#show" do
    before do
      stub_request :get, "/api/v1/workspaces/7", one_record_response
      stub_request :get, "/api/v1/workspaces/8", "errors" => [{ "type" => "system", "message" => "Not found" }]
    end

    context "when id is empty" do
      it "raises an argument error" do
        expect { subject.show(nil) }.to raise_error(ArgumentError)
      end
    end

    context "existed record" do
      it "returns record wrapped in a model" do
        expect(subject.show(7)).to be_a Mavenlink::Workspace
      end
    end

    context "record does not exist" do
      it "raises an error" do
        expect { subject.show(8) }.to raise_error(Mavenlink::InvalidRequestError)
      end
    end
  end

  describe "#search" do
    specify do
      expect(subject.search("text").scope).to include(search: "text")
    end
  end

  describe "#filter" do
    specify do
      expect(subject.filter(recent: true).scope).to include(recent: true)
    end

    context "when include is in the hash" do
      it "lets `#includes` handle the value" do
        expect_any_instance_of(Mavenlink::Request).to receive(:includes).and_call_original
        expect(subject.filter(recent: true, include: "user,custom_field_values").scope).to include(include: %w(user custom_field_values))
      end

      it "does not modify the original param" do
        filters = { some: "filter", include: "association" }
        subject.filter(filters)
        expect(filters).to eq(some: "filter", include: "association")
      end

      context "when the key is a string" do
        it "handles it" do
          expect(subject.filter({ recent: true, include: "user,custom_field_values" }.stringify_keys).scope).to include(include: %w(user custom_field_values))
        end
      end
    end
  end

  describe "#include" do
    specify do
      expect(subject.include(:users).scope).to include(include: %w(users))
    end

    specify do
      expect(subject.include("users").scope).to include(include: %w(users))
    end

    specify do
      expect(subject.include(%w(users clients)).scope).to include(include: %w(users clients))
    end

    specify do
      expect(subject.include("users", "clients").scope).to include(include: %w(users clients))
    end

    context "when a includes already exist" do
      it "appends to the list" do
        expect(subject.include("users").include("custom_field_values").scope).to include(include: %w(users custom_field_values))
      end
    end

    context "when the value is a comma separated string" do
      it "splits the values" do
        expect(subject.include("users,custom_field_values").scope).to include(include: %w(users custom_field_values))
      end
    end

    context "when an association is included more than once" do
      it "only includes the unique values" do
        expect(subject.include(:user).include(:user).scope).to include(include: %w(user))
      end
    end
  end

  describe "#page" do
    specify do
      expect(subject.page(5).scope).to include(page: 5)
    end
  end

  describe "#per_page" do
    specify do
      expect(subject.per_page(5).scope).to include(per_page: 5)
    end
  end

  describe "#limit" do
    specify do
      expect(subject.limit(5).scope).to include(limit: 5)
    end
  end

  describe "#offset" do
    specify do
      expect(subject.offset(5).scope).to include(offset: 5)
    end
  end

  describe "#order" do
    specify do
      expect(subject.order(:id, :desc).scope).to include(order: "id:desc")
    end

    specify do
      expect(subject.order(:id, "desc").scope).to include(order: "id:desc")
    end

    specify do
      expect(subject.order(:id, "DESC").scope).to include(order: "id:desc")
    end

    specify do
      expect(subject.order(:id, true).scope).to include(order: "id:desc")
    end

    specify do
      expect(subject.order(:id, false).scope).to include(order: "id:asc")
    end

    specify do
      expect(subject.order(:id, "asc").scope).to include(order: "id:asc")
    end

    specify do
      expect(subject.order(:id, "ASC").scope).to include(order: "id:asc")
    end

    specify do
      expect(subject.order(:id, :asc).scope).to include(order: "id:asc")
    end
  end

  describe "#build" do
    before do
      subject.scope = { include: "external_references" }
    end

    it "returns a model object of the same type as the collection name" do
      workspace = subject.build(title: "New Workspace")
      expect(workspace).to be_a Mavenlink::Workspace
      expect(workspace.scope).to eq(subject.scope)
    end
  end

  describe "#bulk_create" do
    let(:models) do
      [
        {
          title: "Workspace One",
          description: "Project uno"
        },
        {
          title: "Another Workspace",
          description: "Another project"
        }
      ]
    end

    let(:two_record_response) do
      {
        "count" => 2,
        "results" => [
          {
            "key" => "workspaces",
            "id" => "8"
          },
          {
            "key" => "workspaces",
            "id" => "9"
          }
        ],
        "workspaces" => {
          "8" => {
            "title" => "Workspace One"
          },
          "9" => {
            "title" => "Another Workspace"
          }
        }
      }
    end

    it "posts to the collection with the given models" do
      expect(client).to receive(:post).with(collection_name, collection_name.pluralize => models) { two_record_response }

      response = subject.bulk_create(models)
      expect(response).to be_a Mavenlink::Response
      expect(response).to eq two_record_response
    end

    context "when an include filter is passed" do
      let(:two_record_response) do
        {
          "count" => 2,
          "results" => [
            {
              "key" => "workspaces",
              "id" => "8"
            },
            {
              "key" => "workspaces",
              "id" => "9"
            }
          ],
          "workspaces" => {
            "8" => {
              "title" => "Workspace One",
              "external_reference_ids" => [10]
            },
            "9" => {
              "title" => "Another Workspace",
              "external_reference_ids" => [11]
            }
          },
          "external_references": {
            "10" => {
              "subject_type" => "workspace",
              "subject_id" => 8
            },
            "11" => {
              "subject_type" => "workspace",
              "subject_id" => 9
            }
          }
        }
      end
      let(:filters) { { "include" => "external_references" } }

      it "posts to the collection with the given models and include filters" do
        expect(client).to receive(:post).with(collection_name, { collection_name.pluralize => models }.merge(filters)) { two_record_response }

        response = subject.bulk_create(models, filters)
        expect(response).to be_a Mavenlink::Response
        expect(response).to eq two_record_response
      end
    end
  end

  describe "#create" do
    specify do
      expect(subject.create({})).to be_a Mavenlink::Response
    end

    specify do
      expect(subject.create({})).to eq(one_record_response)
    end
  end

  describe "#update" do
    specify do
      expect(subject.only(7).update(title: "New title")).to be_a Mavenlink::Response
    end

    specify do
      expect(subject.only(7).update(title: "New title")).to eq(one_record_response)
    end

    context "no id specified" do
      specify do
        # NOTE(SZ): should we raise InvalidRequestError instead?
        expect { subject.update(title: "New one") }.to raise_error ArgumentError, /route.*ID/
      end
    end
  end

  describe "#delete" do
    specify do
      expect(subject.only(7).delete).to be_blank
    end

    context "no id specified" do
      specify do
        # NOTE(SZ): should we raise InvalidRequestError instead?
        expect { subject.delete }.to raise_error ArgumentError, /route.*ID/
      end
    end
  end

  describe "#response" do
    specify do
      expect(subject.response).to be_a Mavenlink::Response
    end

    specify do
      expect(subject.response).to eq(response)
    end
  end

  describe "#perform" do
    specify do
      expect(subject.perform).to be_a Mavenlink::Response
    end

    specify do
      expect(subject.perform).to eq(response)
    end

    specify do
      expect(subject.perform { one_record_response }).to be_a Mavenlink::Response
    end

    specify do
      expect(subject.perform { one_record_response }).to eq(one_record_response)
    end

    it "converts the include array to a string" do
      other_filters = { "another" => %w[multi-value filter] }
      expect(client).to receive(:get).with("workspaces", other_filters.merge("include" => "first,second")) { first_page }
      subject.include(%w[first second]).filter(other_filters).perform
    end
  end

  describe "#results" do
    specify do
      expect(subject.results.size).to eq(2)
    end

    # NOTE(SZ): missing specs
  end

  describe "#reload" do
    specify do
      expect(subject.reload.size).to eq(2)
    end

    # NOTE(SZ): missing specs
  end

  describe "#total_pages" do
    specify do
      expect(subject.total_pages).to eq(1)
    end

    # NOTE(SZ): missing specs
  end

  describe "#limit_value" do
    specify do
      expect(subject.limit_value).to eq(2)
    end

    specify do
      expect(subject.limit(5).limit_value).to eq(5)
    end
  end

  describe "#scoped" do
    specify do
      expect(subject.scoped).to eq(subject)
    end
  end

  describe "#to_hash" do
    specify do
      expect(subject.to_hash).to eq(subject.scope)
    end
  end

  describe "#inspect" do
    specify do
      expect(subject.inspect).to eq("#<Mavenlink::Request [<Mavenlink::Workspace:>, <Mavenlink::Workspace:>]>")
    end
  end

  describe "#each_page" do
    specify do
      expect(subject.each_page.to_a).to eq [[{ "title" => "My new project!" }, { "title" => "My second project!" }],
                                            [{ "title" => "My last project!" }]]
    end

    specify do
      subject.each_page.to_a.flatten.tap do |records|
        expect(records[0]).to be_a Mavenlink::Model
        expect(records[1]).to be_a Mavenlink::Model
        expect(records[2]).to be_a Mavenlink::Model
      end
    end

    # This would hang indefinitely
    context "when the response says one result but none are returned", stub_requests: false do
      let(:response) do
        {
          "count" => 1,
          "results" => [],
          "workspaces" => {}
        }
      end

      before do
        stubbed_requests.instance_variable_get(:@stack)[:get].clear
        stub_request :get, %r{api/v1/workspaces(\?page=[0-9]+)?}, response
      end

      it "returns nothing" do
        expect(subject.each_page.to_a.flatten).to be_empty
      end
    end
  end
end
