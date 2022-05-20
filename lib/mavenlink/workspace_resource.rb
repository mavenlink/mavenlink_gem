module Mavenlink
  class WorkspaceResource < Model
    def allocations_matching_scheduled_hours(workspace_resource)
      client.post("#{collection_name}/#{@id}/allocations_matching_scheduled_hours", workspace_resource: workspace_resource)
    end
  end
end
