module Mavenlink
  class TimesheetSubmission < Model
    def approve_submission
      client.put("timesheet_submissions/#{self.id}/approve")
    end

    def reject_submission
      client.put("timesheet_submissions/#{self.id}/reject")
    end
  end
end
