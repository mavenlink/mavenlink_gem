module Mavenlink
  class ProjectAccountingRecord < Model
    def destroy
      client.put("#{collection_name}/delete", ids: id)
    end
    alias delete destroy
  end
end
