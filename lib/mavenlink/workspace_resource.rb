module Mavenlink
  class WorkspaceResource < Model
    def allocations_matching_scheduled_hours
      client.post("#{collection_name}/allocations_matching_scheduled_hours")
    end
  end
end
