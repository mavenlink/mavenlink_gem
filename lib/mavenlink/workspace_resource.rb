module Mavenlink
  class WorkspaceResource < Model
    def allocations_matching_scheduled_hours(hard = false, occurrence = {})
      client.post("#{collection_name}/#{@id}/allocations_matching_scheduled_hours", hard: hard, occurrence: occurrence)
    end
  end
end
