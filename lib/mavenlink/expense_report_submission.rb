module Mavenlink
  class ExpenseReportSubmission < Model
    def approve_submission
      client.put("expense_report_submissions/#{self.id}/approve")
    end

    def reject_submission
      client.put("expense_report_submissions/#{self.id}/reject")
    end
  end
end
