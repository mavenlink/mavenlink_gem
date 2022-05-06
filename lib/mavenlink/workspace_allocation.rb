module Mavenlink
  class WorkspaceAllocation < Model
    def split_allocation(date)
      client.put("#{collection_name}/split", split_date: date, workspace_allocation_id: id)
    end
  end
end
