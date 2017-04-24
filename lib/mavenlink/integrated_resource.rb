module Mavenlink
  class IntegratedResource < Model
    def save
      if valid?
        reload(create_or_update(attributes_for_create_or_update))
        true
      else
        false
      end
    end

    protected

    def update
      raise "Cannot use update, use save instead"
    end

    def create
      raise "Cannot use create, use save instead"
    end

    private

    def create_or_update(attributes)
      request.perform do
        client.post("integrated_resources/create_or_update", { integrated_resource: attributes})
      end
    end

    def attributes_for_create_or_update
      specification_attributes("create_or_update_attributes")
    end
  end
end
