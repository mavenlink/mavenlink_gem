module Mavenlink
  class WorkspaceAllocation < Model
    def split_allocation(date)
      client.put("#{collection_name}/split", split_date: date, workspace_allocation_id: id)
      client.put("#{collection_name}/#{id}", end_date: date.to_date.yesterday.to_s)
    end
  end
end
