module Mavenlink
  class Request
    include Enumerable

    attr_reader :client, :collection_name, :collection_path
    attr_accessor :scope
    DEFAULT_PAGE_LIMIT = 200

    # @param collection_name [String, Symbol]
    # @param client [Mavenlink::Client]
    def initialize(collection_path, collection_name, client = Mavenlink.client)
      @collection_path = collection_path
      @collection_name = collection_name
      @client = client
      @scope = ActiveSupport::HashWithIndifferentAccess.new
    end

    # Returns new chained request
    # @param new_scope [Hash]
    # @return [Mavenlink::Request]
    def chain(new_scope = {})
      new_scope = {} if new_scope.nil?

      self.class.new(collection_path, collection_name, client).tap do |new_request|
        new_request.scope.merge!(scope)
        new_request.scope.merge!(new_scope)
      end
    end

    # @param ids [String, Array]
    # @return [Mavenlink::Request]
    def only(*ids)
      if ids.try(:flatten).present?
        chain(only: param_to_request_array(ids))
      else
        without(:only)
      end
    end

    # @param id [Integer, String]
    # @return [BrainstemAdaptor::Record, nil]
    def find(id)
      only(id).perform.results.first
    end

    # @param id [Integer, String]
    # @return [BrainstemAdaptor::Record, nil]
    def show(id)
      raise ArgumentError if id.to_s.strip.empty?

      response = client.get("#{collection_name}/#{id}", stringify_include_value)
      Mavenlink::Response.new(response, client, scope: scope, collection_name: collection_name).results.first
    end

    # @param text [String]
    # @return [Mavenlink::Request]
    def search(text)
      chain(search: text)
    end

    # @param options [Hash]
    def filter(options)
      options = options.dup
      associations = options.delete(:include) || options.delete("include")
      if associations.present?
        includes(associations).chain(options)
      else
        chain(options)
      end
    end

    # @param associations [String, Array]
    # @return [Mavenlink::Request]
    def includes(*associations)
      current_associations = scope[:include] || []
      associations = associations.flatten
      associations = associations.first.split(",") if associations.length == 1 && associations.first.is_a?(String)
      chain(include: (current_associations << associations.map(&:to_s)).flatten.uniq)
    end
    alias include includes

    # @param [Integer, String]
    # @return [Mavenlink::Request]
    def page(number)
      chain(page: number)
    end

    def current_page
      @scope[:page].try(:to_i) || 1
    end

    # @return [Integer]
    def total_count
      response.total_count
    end

    # Kaminari support
    # @return [Integer]
    def total_pages
      (total_count / (@scope[:per_page].try(:to_f) || 200.0)).ceil
    end

    # Kaminari support
    # @return [Integer]
    def limit_value
      @scope[:limit].try(:to_i) || total_count
    end

    # @param [Integer, String]
    # @return [Mavenlink::Request]
    def per_page(number)
      chain(per_page: number)
    end

    # @param [Integer, String]
    # @return [Mavenlink::Request]
    def limit(number)
      chain(limit: number)
    end

    # @param [Integer, String]
    # @return [Mavenlink::Request]
    def offset(number)
      chain(offset: number)
    end

    # Removes condition from the scope
    # @param key [String, Symbol]
    # @return [Mavenlink::Request] new request
    def without(key)
      chain.tap { |new_scope| new_scope.scope.delete(key) }
    end

    # @param field [String, Symbol]
    # @param direction_or_desc [String, nil, true, false]
    # @example
    #  workspaces.order(:created_at)
    #  workspaces.order(:created_at, :desc)
    #  workspaces.order(:created_at, :asc)
    #  workspaces.order(:created_at, 'DESC')
    #  workspaces.order('created_at:desc')
    # @return [Mavenlink::Request]
    def order(field, direction_or_desc = nil)
      case direction_or_desc
      when :desc, "DESC", "desc", true
        field = "#{field}:desc"
      when :asc, nil, "ASC", "asc", false
        field = "#{field}:asc"
      else
        raise ArgumentError, "Invalid request ordering set '#{direction_or_desc}'"
      end

      chain(order: field.to_s)
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Model]
    def build(attributes)
      "Mavenlink::#{collection_name.classify}".constantize.new(attributes, nil, client, scope)
    end

    # @param models [Array<Hash>]
    # @return [Mavenlink::Response]
    def bulk_create(models, filter = {})
      perform { client.post(collection_name, { collection_name.pluralize => models }.merge(filter)) }
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Response]
    def create(attributes)
      perform { client.post(collection_name, { collection_name.singularize => attributes }.merge(stringify_include_value)) }
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Response]
    def update(attributes)
      perform { client.put(resource_path, { collection_name.singularize => attributes }.merge(stringify_include_value)) }
    end

    # @note Weird non-json response?
    # @return [nil]
    def delete
      client.delete(resource_path)
    end

    # @return [Mavenlink::Response]
    def perform
      response = block_given? ? yield : client.get(collection_path, stringify_include_value)
      Mavenlink::Response.new(response, client, scope: scope, collection_name: collection_name)
    end

    # Returns cached response
    # @return [Mavenlink::Response]
    def response
      @response ||= perform
    end

    def results
      @results ||= response.results
    end
    alias all results

    def reload
      @results = nil
      results
    end

    def each(&block)
      results.each(&block)
    end

    # Iterates through each page, similar to ActiveRecord's #find_in_batches.
    # @todo replace with lazy enumerator for ruby 2.0
    # @param batch_size [Integer]
    # @return [Enumerator<Array<Mavenlink::Model>>]
    def each_page(batch_size = nil, &block)
      Enumerator.new do |result|
        i = 0
        records_passed = 0
        request = per_page(batch_size ||= per_page_size)
        page_records = []
        total_count = Float::INFINITY

        while (records_passed += page_records.count) < total_count
          response = request.page(i += 1).perform
          total_count = response.total_count
          result << page_records = response.results
          break if response.results.empty?
        end
      end.each(&block)
    end

    def per_page_size
      Mavenlink.specification[collection_name]["per_page"] || DEFAULT_PAGE_LIMIT
    end

    def scoped
      self
    end

    def to_hash
      scope
    end

    # @see https://github.com/rails/rails/blob/682d7c7035fed76c42ba6fefa38973387e80409e/activerecord/lib/active_record/relation.rb#L572
    # @return [String]
    def inspect
      entries = to_a.map { |e| "<#{e.class.name}:#{e['id']}>" }
      "#<#{self.class.name} [#{entries.join(', ')}]>"
    end

    # Returns "show" path for the resource
    # @raise [ArgumentError] when ID is not included in criteria
    # @return [String]
    def resource_path
      (id = @scope[:only]) || raise(ArgumentError, "No route matches source path without an ID")
      "#{collection_path}/#{id}"
    end

    private

    def stringify_include_value
      scope.each_with_object({}) do |pair, obj|
        value = pair[0].eql?("include") ? pair[1].join(",") : pair[1]
        obj[pair[0]] = value
      end
    end

    # Builds comma-separated query param
    # @param param [Array, String]
    def param_to_request_array(param)
      case param
      when Array
        param.join(",").gsub(/\s+/, "")
      when String, Symbol
        param.to_s.gsub(/\s+/, "")
      else
        raise ArgumentError, "Expected Array, got #{param.class.name}"
      end
    end
  end
end
