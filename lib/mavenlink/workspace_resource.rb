module Mavenlink
  class WorkspaceResource < Model
    def allocations_matching_scheduled_hours(workspace_id)
      client.post("#{collection_name}/allocations_matching_scheduled_hours", workspace_id: workspace_id)
    end
  end
end
