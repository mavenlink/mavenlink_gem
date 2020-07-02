module Mavenlink
  class Submission < Model
    def approve_submission(description = nil)
      client.put("#{collection_name}/#{id}/approve", resolution: { description: description })
    end

    def cancel_submission(description = nil)
      client.put("#{collection_name}/#{id}/cancel", resolution: { description: description })
    end

    def reject_submission(description = nil)
      client.put("#{collection_name}/#{id}/reject", resolution: { description: description })
    end
  end
end
