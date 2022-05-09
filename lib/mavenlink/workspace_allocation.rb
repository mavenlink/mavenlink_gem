module Mavenlink
  class WorkspaceAllocation < Model
    def split_allocation(date)
      response = client.put("#{collection_name}/split", split_date: date, workspace_allocation_id: id)
      ## update
      update_attributes(response["workspace_allocations"].values.first)
      ## create
      Mavenlink::WorkspaceAllocation.new(response["workspace_allocations"].values.last, nil, client)
    end
  end
end
