module Mavenlink
  class WorkspaceResource < Model
    def allocations_matching_scheduled_hours(id)
      client.post("#{collection_name}/allocations_matching_scheduled_hours", id: id)
    end
  end
end
