module Mavenlink
  class Model < BrainstemAdaptor::Record
    include ActiveModel::Validations

    attr_reader :client, :scope

    class << self
      delegate :only, :find, :search, :filter, :page, :total_count, :per_page, :limit, :offset, :order, :all, to: :scoped
    end

    # @return [String]
    def self.collection_name
      (name || "undefined").split(/\W+/, 2).last.tableize.pluralize
    end

    # @param models [Array<Hash>]
    # @return [Array<Mavenlink::Model>]
    def self.bulk_create(models)
      scoped.bulk_create(models).results
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Model]
    def self.create(attributes = {})
      new(attributes).tap(&:save)
    end

    # @raise [Mavenlink::RecordInvalidError]
    # @param attributes [Hash]
    # @return [Mavenlink::Model]
    def self.create!(attributes = {})
      create(attributes).tap do |record|
        record.valid? || raise(RecordInvalidError, record)
      end
    end

    # @return [Mavenlink::Request]
    def self.includes(*args)
      scoped.include(*args)
    end

    # @param client [Mavenlink::Client]
    # @return [Mavenlink::Request]
    def self.scoped(client = Mavenlink.client, args = {})
      Mavenlink::Request.new(collection_path(**args), collection_name, client)
    end

    # @return [Mavenlink::Request]
    def scoped_im(args = {})
      Mavenlink::Request.new(self.class.collection_path(**args), client)
    end

    # @param model_class [Mavenlink::Model]
    def self.inherited(model_class)
      ::Mavenlink::Model.models[model_class.collection_name] = model_class

      # Applies specification file to the model
      Mavenlink::Specificators::Attribute.apply(model_class)
      Mavenlink::Specificators::Association.apply(model_class)
      Mavenlink::Specificators::Validation.apply(model_class)
    end

    def self.collection_path(_ = {})
      collection_name
    end

    # Returns all models registered in the app
    # @return [Hash<String, Class>] key is collection name and value is a model assigned to this collection
    def self.models
      @models ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    # Returns collection specification
    # @return [Hash]
    def self.specification
      @specification ||= Mavenlink.specification[collection_name] || {}
    end

    # @todo REFACTOR NA
    # @param association_name [String, Symbol]
    def self.association(association_name)
      define_method association_name do |reload = false|
        return nil if new_record?

        association = association_by_name(association_name)
        reload = true unless loaded?(association) || associations_cache.key?(association_name)

        if reload
          reload_association(association)
          associations_cache[association_name] = fetch_association_records(association)
        elsif associations_cache.key?(association_name)
          associations_cache[association_name]
        else
          associations_cache[association_name] = fetch_association_records(association)
        end
      end
    end

    # @param names [String, Symbol]
    def self.attribute(*names)
      names.each do |name|
        define_method(name) { self[name.to_s] }
        define_method("#{name}=") { |value| self[name.to_s] = value }
      end
    end

    # Returns list of available attributes
    # @return [Array<String>]
    def self.attributes
      specification["attributes"] ||= []
    end

    # Returns list of all available attributes
    # @return [Array<String>]
    def self.available_attributes
      create_attributes | update_attributes | attributes
    end

    # Returns the list of attributes available for new record
    # @return [Array<String>]
    def self.create_attributes
      specification["create_attributes"] ||= []
    end

    # Returns the list of attributes available for update
    # @return [Array<String>]
    def self.update_attributes
      specification["update_attributes"] ||= []
    end

    # @param source_record [Brainstem::Record, nil]
    # @param client [Mavenlink::Client]
    # @param scope [Hash] filters used when requesting the model
    def self.wrap(source_record = nil, client = Mavenlink.client, scope = {})
      new({}, source_record, client, scope)
    end

    # @param attributes [Hash]
    # @param source_record [BrainstemAdaptor::Record]
    # @param client [Mavenlink::Client]
    # @param scope [Hash] filters used when requesting the model
    def initialize(attributes = {}, source_record = nil, client = Mavenlink.client, scope = {})
      super(self.class.collection_name, (attributes[:id] || attributes["id"] || source_record.try(:id)), source_record.try(:response))
      @client = client
      @associations_specification = self.class.specification["associations"]
      @scope = scope.deep_dup.except("page", "per_page", "only")
      merge!(attributes)
    end

    # @param attributes [Hash]
    def attributes=(attributes)
      merge!(attributes)
    end

    def persisted?
      !!id
    end

    def new_record?
      !persisted?
    end

    # @return [true, false]
    def save
      if valid?
        reload(new_record? ? create : update)
        true
      else
        false
      end
    end

    # @raise [Mavenlink::RecordInvalidError]
    # @return [true]
    def save!
      save || raise(Mavenlink::RecordInvalidError, self)
    end

    # @param attributes [Hash]
    # @return [true, false]
    def update_attributes(attributes)
      self.attributes = attributes
      save
    end

    # @param attributes [Hash]
    # @raise [Mavenlink::RecordInvalidError]
    # @return [true]
    def update_attributes!(attributes)
      self.attributes = attributes
      save!
    end

    # @note does not work, don't know what to do with removed record.
    #  will just return RecordNotFound error if you call #save after #destroy
    def destroy
      request.delete
    end
    alias delete destroy

    # Reloads record from server
    # @return [self]
    def reload(response = nil)
      (response ||= request.find(id).try(:response)) || raise(RecordNotFoundError, request)
      @id ||= response.results.first.try(:[], "id")
      load_fields_with(response)
      self
    end

    # @overload
    # @param context [:create, :update]
    # @return [true, false]
    def valid?(context = saving_context)
      Mavenlink::Settings[:default][:perform_validations] ? super(context.try(:to_sym)) : true
    end

    # @return [String, nil]
    def to_param
      id.try(:to_s)
    end

    def association_load_filters
      {}
    end

    protected

    # @return [Mavenlink::Response]
    def create
      request.create(attributes_for_create)
    end

    # @return [Mavenlink::Response]
    def update
      request.update(attributes_for_update)
    end

    # @return [Hash]
    def attributes_for_create
      specification_attributes("create_attributes")
    end

    # @return [Hash]
    def attributes_for_update
      specification_attributes("update_attributes")
    end

    # @return [Mavenlink::Request]
    def request
      collection_scope.only(id)
    end

    private

    # Stores requested data in a Hash
    # @return [Hash]
    def associations_cache
      @associations_cache ||= {}.with_indifferent_access
    end

    # @return [Mavenlink::Request]
    def collection_scope
      @collection_scope ||= self.class.scoped(client).chain(scope)
    end

    # @param association [BrainstemAdaptor::Association]
    # @return [Array<Mavenlink::Model>, nil]
    def fetch_association_records(association)
      records = association.reflect
      return unless records

      wrapper = proc { |record| Mavenlink::Model.models[association.collection_name].wrap(record, client) }
      records.is_a?(BrainstemAdaptor::Association) ? records.map(&wrapper) : wrapper.call(records, client)
    end

    # @param association [BrainstemAdaptor::Association]
    def reload_association(association)
      (response = request.filter(association_load_filters).include(association.name).find(id).try(:response)) || raise(RecordNotFoundError, request)
      load_fields_with(response, [association.foreign_key])
    end

    def saving_context
      new_record? ? :create : :update
    end

    # @param key [String]
    # @return [Hash]
    def specification_attributes(key)
      {}.tap do |result|
        to_hash.slice(*self.class.specification[key]).each do |attr_name, value|
          result[attr_name] = value
        end
      end
    end

    def loaded?(association)
      associations_cache[association.name] = nil if association.record[association.foreign_key].nil?
      association.loaded?
    end
  end
end
