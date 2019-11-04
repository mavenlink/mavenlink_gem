module Mavenlink
  class TimesheetSubmission < Model
    def approve_submission
      client.put("timesheet_submissions/#{id}/approve")
    end

    def reject_submission
      client.put("timesheet_submissions/#{id}/reject")
    end
  end
end
