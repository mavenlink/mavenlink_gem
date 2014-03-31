module Mavenlink
  class Request
    include Enumerable

    attr_reader :client, :collection_name
    attr_accessor :scope

    # @param collection_name [String, Symbol]
    # @param client [Mavenlink::Client]
    def initialize(collection_name, client = Mavenlink.client)
      @collection_name = collection_name
      @client = client
      @scope = ActiveSupport::HashWithIndifferentAccess.new
    end

    # Returns new chained request
    # @param new_scope [Hash]
    # @return [Mavenlink::Request]
    def chain(new_scope = {})
      self.class.new(collection_name, client).tap do |new_request|
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

    # @param text [String]
    # @return [Mavenlink::Request]
    def search(text)
      chain(search: text)
    end

    # @param options [Hash]
    def filter(options)
      chain(options)
    end

    # @param associations [String, Array]
    # @return [Mavenlink::Request]
    def include(*associations)
      chain(include: param_to_request_array(associations))
    end

    # @param [Integer, String]
    # @return [Mavenlink::Request]
    def page(number)
      chain(page: number)
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
      when :desc, 'DESC', 'desc', true
        field = "#{field}:desc"
      when :asc, nil, 'ASC', 'asc', false
      else
        raise ArgumentError, "Invalid request ordering set '#{direction_or_desc}'"
      end

      chain(order: field.to_s)
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Response]
    def create(attributes)
      perform { client.post(collection_name, {collection_name.singularize => attributes}) }
    end

    # @param attributes [Hash]
    # @return [Mavenlink::Response]
    def update(attributes)
      perform { client.put(resource_path, {collection_name.singularize => attributes}) }
    end

    # @note Weird non-json response?
    # @return [nil]
    def delete
      client.delete(resource_path)
    end

    # @return [Mavenlink::Response]
    def perform
      response = block_given? ? yield : client.get(collection_name, scope)
      Mavenlink::Response.new(response)
    end

    def results
      @results ||= perform.results
    end
    alias_method :all, :results

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
    def each_page(batch_size = 200, &block)
      Enumerator.new do |result|
        i = 0
        records_passed = 0
        request = per_page(batch_size)
        page_records = []
        total_count = Float::INFINITY

        while (records_passed += page_records.count) < total_count
          response = request.page(i+=1).perform
          total_count = response.total_count
          result << page_records = response.results
        end
      end.each(&block)
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
      id = @scope[:only] or raise ArgumentError, 'No route matches source path without an ID'
      "#{collection_name}/#{id}"
    end

    private

    # Builds comma-separated query param
    # @param param [Array, String]
    def param_to_request_array(param)
      case param
      when Array
        param.join(',').gsub(/\s+/, '')
      when String, Symbol
        param.to_s.gsub(/\s+/, '')
      else
        raise ArgumentError, "Expected Array, got #{param.class.name}"
      end
    end
  end
end
