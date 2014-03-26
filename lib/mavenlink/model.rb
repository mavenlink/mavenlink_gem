module Mavenlink
  class Model < BrainstemAdaptor::Record
    include ActiveModel::Validations

    # Sets collection name
    # @example
    #   class Customer < Mavenlink::Model
    #     collection :users
    #   end
    def self.collection(name)
      @collection_name = name
    end

    # @return [String]
    def self.collection_name
      @collection_name || self.name.split(/\W+/).last.tableize.pluralize
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Model]
    def self.create(attributes = {})
      self.new(attributes).tap(&:save)
    end

    # @raise [Mavenlink::RecordInvalidError]
    # @param attributes [Hash]
    # @return [Mavenlink::Model]
    def self.create!(attributes = {})
      create(attributes).tap do |record|
        record.valid? or raise RecordInvalidError.new(record)
      end
    end

    # @return [Mavenlink::Request]
    def self.scoped
      Mavenlink::Request.new(collection_name)
    end

    # @param id [Integer, String]
    def self.find(id)
      scoped.find(id)
    end

    # @param model_class [Mavenlink::Model]
    def self.inherited(model_class)
      ::Mavenlink::Model.models[model_class.collection_name] = model_class

      # Declare attribute accessors (TODO: replace with Hashie?)
      (model_class.available_attributes).each do |attr|
        model_class.attribute attr
      end

      # Declare relations
      (model_class.specification['associations'] || {}).keys.each do |association_name|
        model_class.association association_name
      end

      # Declare validations (REFACTOR)
      to_validation_options = lambda { |options|
        if options.is_a?(Hash)
          options.symbolize_keys!
          options.keys.each { |key| to_validation_options.call(options[key]) }
        end
        options
      }

      (model_class.specification['validations'] || {}).each do |fields, options|
        model_class.validates(*fields, to_validation_options.call(options))
      end
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
        return [] if new_record?

        association = association_by_name(association_name)
        reload = true unless association.loaded?

        if reload
          reload_association(association)
          associations_cache[association_name] = fetch_association_records(association)
        elsif associations_cache.has_key?(association_name)
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
      specification['attributes'] ||= []
    end

    # Returns list of all available attributes
    # @return [Array<String>]
    def self.available_attributes
      create_attributes | update_attributes | attributes
    end

    # Returns the list of attributes available for new record
    # @return [Array<String>]
    def self.create_attributes
      specification['create_attributes'] ||= []
    end

    # Returns the list of attributes available for update
    # @return [Array<String>]
    def self.update_attributes
      specification['update_attributes'] ||= []
    end

    # @param source_record [Brainstem::Record, nil]
    def self.wrap(source_record = nil)
      self.new({}, source_record)
    end

    # @param attributes [Hash]
    # @param source_record [BrainstemAdaptor::Record]
    def initialize(attributes = {}, source_record = nil)
      super(self.class.collection_name, source_record.try(:id), source_record.try(:response))
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
        response = new_record? ? request.create(create_attributes) : request.update(update_attributes)
        reload(response)
        true
      else
        false
      end
    end

    # @raise [Mavenlink::RecordInvalidError]
    # @return [true]
    def save!
      save or raise Mavenlink::RecordInvalidError.new(self)
    end

    # @note does not work, don't know what to do with removed record.
    #  will just return RecordNotFound error if you call #save after #destroy
    def destroy
      request.delete
    end
    alias_method :delete, :destroy

    # Reloads record from server
    # @return [self]
    def reload(response = nil)
      response ||= request.find(id).try(:response) or raise RecordNotFoundError.new(request)
      @id ||= response.results.first.try(:[], 'id')
      load_fields_with(response)
      self
    end

    # @overload
    # @param context [:create, :update]
    # @return [true, false]
    def valid?(context = saving_context)
      super(context.try(:to_sym))
    end

    protected

    # @return [Hash]
    def create_attributes
      specification_attributes('create_attributes')
    end

    # @return [Hash]
    def update_attributes
      specification_attributes('update_attributes')
    end

    # @return [Mavenlink::Request]
    def request
      @request ||= self.class.scoped.only(id)
    end

    private

    # Stores requested data in a Hash
    # @return [Hash]
    def associations_cache
      @associations_cache ||= {}.with_indifferent_access
    end

    # @param association [BrainstemAdaptor::Association]
    # @return [Array<Mavenlink::Model>, nil]
    def fetch_association_records(association)
      records = association.reflect

      if records
        wrapper = proc { |record| Mavenlink::Model.models[association.collection_name].wrap(record) }
        records.kind_of?(Enumerable) ? records.map(&wrapper) : wrapper.call(records)
      end
    end

    # @param association [BrainstemAdaptor::Association]
    def reload_association(association)
      response = request.include(association.name).find(id).try(:response) or raise RecordNotFoundError.new(request)
      load_fields_with(response, [association.foreign_key])
    end

    def saving_context
      new_record? ? :create : :update
    end

    # @param key [String]
    # @return [Hash]
    def specification_attributes(key)
      {}.tap do |result|
        self.slice(*self.class.specification[key]).each do |attr_name, value|
          result[attr_name] = value
        end
      end
    end
  end
end
