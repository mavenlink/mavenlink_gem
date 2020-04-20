module Mavenlink
  module ScheduledJobs
    class InsightsReportExport < Model
      def latest
        raise Mavenlink::RecordInvalidError, self unless persisted?

        client.get("#{collection_name}/#{id}/results/latest")
      end
    end
  end
end
